using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Runtime.InteropServices;

namespace CLib
{
    public static class FunctionLoader
    {
        [StructLayout(LayoutKind.Explicit)]
        private struct IMAGE_DOS_HEADER
        {
            [FieldOffset(0)] [MarshalAs(UnmanagedType.ByValArray, SizeConst = 2)] public char[] e_magic;
            [FieldOffset(60)] public int e_lfanew;

            public bool isValid => new string(e_magic) == "MZ";
        }

        [StructLayout(LayoutKind.Explicit)]
        public struct IMAGE_FILE_HEADER
        {
            [FieldOffset(0)] public ushort Machine;
        }

        [StructLayout(LayoutKind.Sequential)]
        public struct IMAGE_DATA_DIRECTORY
        {
            public int VirtualAddress;
            public int Size;
        }

        [StructLayout(LayoutKind.Explicit)]
        public struct IMAGE_NT_HEADERS
        {
            [FieldOffset(0)] [MarshalAs(UnmanagedType.ByValArray, SizeConst = 4)] public char[] Signature;
            [FieldOffset(4)] public IMAGE_FILE_HEADER FileHeader;
            [FieldOffset(120)] public IMAGE_DATA_DIRECTORY ExportTable32;
            [FieldOffset(136)] public IMAGE_DATA_DIRECTORY ExportTable64;
            [FieldOffset(232)] public IMAGE_DATA_DIRECTORY CLRRuntimeHeader32;
            [FieldOffset(248)] public IMAGE_DATA_DIRECTORY CLRRuntimeHeader64;

            public bool isValid => new string(Signature) == "PE\0\0";
        }

        [StructLayout(LayoutKind.Explicit)]
        public struct IMAGE_EXPORT_DIRECTORY
        {
            [FieldOffset(24)]
            public int NumberOfNames;
            [FieldOffset(32)]
            public int AddressOfNames;
        }


        [Flags]
        private enum LoadLibraryFlags : uint
        {
            DONT_RESOLVE_DLL_REFERENCES = 0x00000001,
        }

        [DllImport("kernel32.dll", SetLastError = true)]
        private static extern IntPtr LoadLibraryEx(string lpFileName, IntPtr hReservedNull, LoadLibraryFlags dwFlags);

        [DllImport("kernel32.dll", SetLastError = true)]
        [return: MarshalAs(UnmanagedType.Bool)]
        private static extern bool FreeLibrary(IntPtr hModule);

        [DllImport("Kernel32.dll")]
        private static extern IntPtr GetProcAddress(IntPtr hModule, string procName);

        [DllImport("kernel32.dll")]
        private static extern int GetLastError();

        public static List<string> ExportTable(string dllPath)
        {
            var hModule = LoadLibraryEx(dllPath, IntPtr.Zero, LoadLibraryFlags.DONT_RESOLVE_DLL_REFERENCES);
            if (hModule == IntPtr.Zero)
                throw new Win32Exception(GetLastError());

            try
            {
                var imageDosHeader = Marshal.PtrToStructure<IMAGE_DOS_HEADER>(hModule);
                if (!imageDosHeader.isValid)
                    throw new Exception("IMAGE_DOS_HEADER is invalid: " + dllPath);

                var imageNtHeaders = Marshal.PtrToStructure<IMAGE_NT_HEADERS>(hModule + imageDosHeader.e_lfanew);
                if (!imageNtHeaders.isValid)
                    throw new Exception("IMAGE_NT_HEADERS is invalid: " + dllPath);

                IMAGE_DATA_DIRECTORY exportTabledataDirectory;
                switch (imageNtHeaders.FileHeader.Machine)
                {
                    case 0x014C:
                        exportTabledataDirectory = imageNtHeaders.ExportTable32;
                        break;
                    case 0x8664:
                        exportTabledataDirectory = imageNtHeaders.ExportTable64;
                        break;
                    default:
                        throw new Exception("File is not a valid x86 or x64 executable: " + dllPath);
                }

                if (exportTabledataDirectory.Size == 0)
                    return new List<string>();

                var exportTable =
                    Marshal.PtrToStructure<IMAGE_EXPORT_DIRECTORY>(hModule + exportTabledataDirectory.VirtualAddress);

                var addressOfNames = Marshal.ReadInt32(hModule + exportTable.AddressOfNames);
                var names = new List<string>();
                for (var i = 0; i < exportTable.NumberOfNames; i++)
                {
                    var name = Marshal.PtrToStringAnsi(hModule + addressOfNames + (i*4));
                    if (name == null)
                        continue;

                    names.Add(name);
                }

                return names;
            }
            finally
            {
                FreeLibrary(hModule);
            }
        }

        public static T LoadFunction<T>(string dllPath, string functionName)
        {
            var hModule = LoadLibraryEx(dllPath, IntPtr.Zero, 0);
            if (hModule == IntPtr.Zero)
                throw new ArgumentException("Dll not found: " + dllPath + " error code: " + GetLastError());

            DllEntry.Debugger.Log(functionName);
            DllEntry.Debugger.Log(functionName.Length);
            var functionAddress = GetProcAddress(hModule, functionName);
            if (functionAddress == IntPtr.Zero)
                throw new ArgumentException("Function not found: " + functionName + " error code: " + GetLastError());

            return Marshal.GetDelegateForFunctionPointer<T>(functionAddress);
        }
    }
}