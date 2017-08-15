using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Net.Sockets;
using System.Net.WebSockets;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Security.Cryptography;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace CLibWebSocket
{
    public static class AsyncHelpers {
        /// <summary>
        /// Execute's an async Task<T> method which has a void return value synchronously
        /// </summary>
        /// <param name="task">Task<T> method to execute</param>
        public static void RunSync(Func<Task> task) {
            var oldContext = SynchronizationContext.Current;
            var synch = new ExclusiveSynchronizationContext();
            SynchronizationContext.SetSynchronizationContext(synch);
            synch.Post(async _ =>
            {
                try {
                    await task();
                } catch (Exception e) {
                    synch.InnerException = e;
                    throw;
                } finally {
                    synch.EndMessageLoop();
                }
            }, null);
            synch.BeginMessageLoop();

            SynchronizationContext.SetSynchronizationContext(oldContext);
        }

        /// <summary>
        /// Execute's an async Task<T> method which has a T return type synchronously
        /// </summary>
        /// <typeparam name="T">Return Type</typeparam>
        /// <param name="task">Task<T> method to execute</param>
        /// <returns></returns>
        public static T RunSync<T>(Func<Task<T>> task) {
            var oldContext = SynchronizationContext.Current;
            var synch = new ExclusiveSynchronizationContext();
            SynchronizationContext.SetSynchronizationContext(synch);
            T ret = default(T);
            synch.Post(async _ =>
            {
                try {
                    ret = await task();
                } catch (Exception e) {
                    synch.InnerException = e;
                    throw;
                } finally {
                    synch.EndMessageLoop();
                }
            }, null);
            synch.BeginMessageLoop();
            SynchronizationContext.SetSynchronizationContext(oldContext);
            return ret;
        }

        private class ExclusiveSynchronizationContext : SynchronizationContext {
            private bool done;
            public Exception InnerException { get; set; }
            readonly AutoResetEvent workItemsWaiting = new AutoResetEvent(false);
            readonly Queue<Tuple<SendOrPostCallback, object>> items =
                new Queue<Tuple<SendOrPostCallback, object>>();

            public override void Send(SendOrPostCallback d, object state) {
                throw new NotSupportedException("We cannot send to our same thread");
            }

            public override void Post(SendOrPostCallback d, object state) {
                lock (items) {
                    items.Enqueue(Tuple.Create(d, state));
                }
                workItemsWaiting.Set();
            }

            public void EndMessageLoop() {
                Post(_ => done = true, null);
            }

            public void BeginMessageLoop() {
                while (!done) {
                    Tuple<SendOrPostCallback, object> task = null;
                    lock (items) {
                        if (items.Count > 0) {
                            task = items.Dequeue();
                        }
                    }
                    if (task != null) {
                        task.Item1(task.Item2);
                        if (InnerException != null) // the method threw an exeption
                        {
                            throw new AggregateException("AsyncHelpers.Run method threw an exception.", InnerException);
                        }
                    } else {
                        workItemsWaiting.WaitOne();
                    }
                }
            }

            public override SynchronizationContext CreateCopy() {
                return this;
            }
        }
    }

    public class DllEntry {
        private static Dictionary<string, ClientWebSocket> sockets = new Dictionary<string, ClientWebSocket>();

        static DllEntry() {
            System.IO.File.WriteAllText("CLibWebSocket.log", string.Empty);
        }

#if WIN64
        [DllExport("RVExtension")]
#else
        [DllExport("_RVExtension@12", CallingConvention.StdCall)]
#endif
        public static void RVExtension(StringBuilder output, int outputSize, [MarshalAs(UnmanagedType.LPStr)] string input) {
            if (input != "version")
                return;

            var executingAssembly = Assembly.GetExecutingAssembly();
            try {
                var location = executingAssembly.Location;
                if (location == null)
                    throw new Exception("Assembly location not found");
                output.Append(FileVersionInfo.GetVersionInfo(location).FileVersion);
            } catch (Exception e) {
                output.Append(e.Message);
            }
        }

        [DllExport("Connect")]
        public static string Connect(string address) {
            string hash = "";
            using (SHA1Managed sha1 = new SHA1Managed()) {
                hash = string.Join("", sha1.ComputeHash(Encoding.Default.GetBytes(address)).Select(b => b.ToString("x2"))).Substring(0, 7);
            }

            if (DllEntry.sockets.ContainsKey(hash) && DllEntry.sockets[hash].State != WebSocketState.Open) {
                Log("Closed");
                DllEntry.sockets[hash].Abort();
                DllEntry.sockets.Remove(hash);
            }

            if (!DllEntry.sockets.ContainsKey(hash)) {
                ClientWebSocket socket = new ClientWebSocket();
                DllEntry.sockets.Add(hash, socket);
                Log("Connecting");
                AsyncHelpers.RunSync(async () => {
                    try {
                        await socket.ConnectAsync(new Uri(address), CancellationToken.None);
                    } catch (Exception e) {
                        Log("Error: ", e.GetType(), e.Message);
                    }
                });

                if (socket.State == WebSocketState.Open) {
                    Log("Connected");
                } else {
                    Log("Connecting error");
                    return "error";
                }
            }

            return hash;
        }

        [DllExport("IsConnected")]
        public static string IsConnected(string hash)
        {
            if (!DllEntry.sockets.ContainsKey(hash))
            {
                return "false";
            }

            if (DllEntry.sockets.ContainsKey(hash) && DllEntry.sockets[hash].State != WebSocketState.Open)
            {
                Log("Closed");
                DllEntry.sockets[hash].Abort();
                DllEntry.sockets.Remove(hash);
                return "false";
            }

            return "true";
        }

        [DllExport("Send")]
        public static string Send(string data) {
            string[] dataParts = data.Split(new char[] { ':' }, 2);
            string hash = dataParts[0];
            data = dataParts[1];
            Log(data);
            if (!DllEntry.sockets.ContainsKey(hash))
                throw new ArgumentException("Socket for address not connected");

            ClientWebSocket socket = DllEntry.sockets[hash];

            Task task = new Task(async () => {
                Log("Sending: ", data);
                await socket.SendAsync(new ArraySegment<byte>(Encoding.Default.GetBytes(data)), WebSocketMessageType.Text, true, CancellationToken.None);
                Log("Sended");
            });
            task.RunSynchronously();

            return "Success";
        }

        private static void Log(params object[] obj) {
            System.IO.File.AppendAllText("CLibWebSocket.log", string.Concat(DateTime.Now.ToString("HH:mm:ss.fff"), " ", string.Concat(obj), "\r\n"));
        }
    }
}
