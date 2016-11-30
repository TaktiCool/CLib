using System;
using System.Runtime.InteropServices;

namespace CLib
{
    public class FunctionLoader
    {
        [DllImport("Kernel32.dll")]
        private static extern IntPtr LoadLibrary(string path);

        [DllImport("Kernel32.dll")]
        private static extern IntPtr GetProcAddress(IntPtr hModule, string procName);

        [DllImport("kernel32.dll")]
        private static extern uint GetLastError();

        public static T LoadFunction<T>(string dllPath, string functionName)
        {
            var hModule = LoadLibrary(dllPath);
            if (hModule == IntPtr.Zero)
                throw new ArgumentException("Dll not found: " + dllPath + " error code: " + GetLastError());

            var functionAddress = GetProcAddress(hModule, functionName);
            if (functionAddress == IntPtr.Zero)
                throw new ArgumentException("Function not found: " + functionName + " error code: " + GetLastError());

            return Marshal.GetDelegateForFunctionPointer<T>(functionAddress);
        }
    }
}