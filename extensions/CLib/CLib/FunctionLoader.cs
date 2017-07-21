using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Runtime.InteropServices;
using static CLib.NativeMethods;

namespace CLib
{
    public static class FunctionLoader
    {
        public static List<string> ExportTable(string dllPath)
        {
            var hModule = LoadLibraryEx(dllPath, IntPtr.Zero, LoadLibraryFlags.DONT_RESOLVE_DLL_REFERENCES);
            if (hModule == IntPtr.Zero)
                throw new Win32Exception(GetLastError());

            try
            {
                var imageDosHeader = Marshal.PtrToStructure<IMAGE_DOS_HEADER>(hModule);
                if (!imageDosHeader.IsValid)
                    throw new Exception("IMAGE_DOS_HEADER is invalid: " + dllPath);

#if WIN64
                var imageNtHeaders = Marshal.PtrToStructure<IMAGE_NT_HEADERS64>(hModule + imageDosHeader.e_lfanew);
#else
                var imageNtHeaders = Marshal.PtrToStructure<IMAGE_NT_HEADERS32>(hModule + imageDosHeader.e_lfanew);
#endif
                if (!imageNtHeaders.IsValid)
                    throw new Exception("IMAGE_NT_HEADERS is invalid: " + dllPath);

                IMAGE_DATA_DIRECTORY exportTabledataDirectory = imageNtHeaders.OptionalHeader.ExportTable;
                if (exportTabledataDirectory.Size == 0)
                    return new List<string>();

                var exportTable =
                    Marshal.PtrToStructure<IMAGE_EXPORT_DIRECTORY>(hModule + exportTabledataDirectory.VirtualAddress);

                var names = new List<string>();
                for (var i = 0; i < exportTable.NumberOfNames; i++)
                {
                    var name = Marshal.PtrToStringAnsi(hModule + Marshal.ReadInt32(hModule + exportTable.AddressOfNames + (i * 4)));
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

            var functionAddress = GetProcAddress(hModule, functionName);
            if (functionAddress == IntPtr.Zero)
                throw new ArgumentException("Function not found: " + functionName + " error code: " + GetLastError());

            return Marshal.GetDelegateForFunctionPointer<T>(functionAddress);
        }
    }
}