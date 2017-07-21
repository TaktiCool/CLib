using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Runtime.InteropServices;

namespace CLib
{
	public static class NativeMethods
	{
		[StructLayout(LayoutKind.Explicit)]
		internal struct IMAGE_DOS_HEADER
		{
			[FieldOffset(0)]
			[MarshalAs(UnmanagedType.ByValArray, SizeConst = 2)]
			public char[] e_magic;
			[FieldOffset(60)]
			public int e_lfanew;

			public bool IsValid => new string(e_magic) == "MZ";
		}

		[StructLayout(LayoutKind.Explicit)]
		public struct IMAGE_FILE_HEADER
		{
			[FieldOffset(0)]
			public ushort Machine;
		}

		[StructLayout(LayoutKind.Sequential)]
		public struct IMAGE_DATA_DIRECTORY
		{
			public int VirtualAddress;
			public int Size;
		}

		[StructLayout(LayoutKind.Explicit)]
		public struct IMAGE_OPTIONAL_HEADER32
		{
			[FieldOffset(0)]
			public ushort Magic;
			[FieldOffset(2)]
			public byte MajorLinkerVersion;
			[FieldOffset(3)]
			public byte MinorLinkerVersion;
			[FieldOffset(4)]
			public uint SizeOfCode;
			[FieldOffset(8)]
			public uint SizeOfInitializedData;
			[FieldOffset(12)]
			public uint SizeOfUninitializedData;
			[FieldOffset(16)]
			public uint AddressOfEntryPoint;
			[FieldOffset(20)]
			public uint BaseOfCode;
			// PE32 contains this additional field
			[FieldOffset(24)]
			public uint BaseOfData;
			[FieldOffset(28)]
			public uint ImageBase;
			[FieldOffset(32)]
			public uint SectionAlignment;
			[FieldOffset(36)]
			public uint FileAlignment;
			[FieldOffset(40)]
			public ushort MajorOperatingSystemVersion;
			[FieldOffset(42)]
			public ushort MinorOperatingSystemVersion;
			[FieldOffset(44)]
			public ushort MajorImageVersion;
			[FieldOffset(46)]
			public ushort MinorImageVersion;
			[FieldOffset(48)]
			public ushort MajorSubsystemVersion;
			[FieldOffset(50)]
			public ushort MinorSubsystemVersion;
			[FieldOffset(52)]
			public uint Win32VersionValue;
			[FieldOffset(56)]
			public uint SizeOfImage;
			[FieldOffset(60)]
			public uint SizeOfHeaders;
			[FieldOffset(64)]
			public uint CheckSum;
			[FieldOffset(68)]
			public ushort Subsystem;
			[FieldOffset(70)]
			public ushort DllCharacteristics;
			[FieldOffset(72)]
			public uint SizeOfStackReserve;
			[FieldOffset(76)]
			public uint SizeOfStackCommit;
			[FieldOffset(80)]
			public uint SizeOfHeapReserve;
			[FieldOffset(84)]
			public uint SizeOfHeapCommit;
			[FieldOffset(88)]
			public uint LoaderFlags;
			[FieldOffset(92)]
			public uint NumberOfRvaAndSizes;
			[FieldOffset(96)]
			public IMAGE_DATA_DIRECTORY ExportTable;
			[FieldOffset(104)]
			public IMAGE_DATA_DIRECTORY ImportTable;
			[FieldOffset(112)]
			public IMAGE_DATA_DIRECTORY ResourceTable;
			[FieldOffset(120)]
			public IMAGE_DATA_DIRECTORY ExceptionTable;
			[FieldOffset(128)]
			public IMAGE_DATA_DIRECTORY CertificateTable;
			[FieldOffset(136)]
			public IMAGE_DATA_DIRECTORY BaseRelocationTable;
			[FieldOffset(144)]
			public IMAGE_DATA_DIRECTORY Debug;
			[FieldOffset(152)]
			public IMAGE_DATA_DIRECTORY Architecture;
			[FieldOffset(160)]
			public IMAGE_DATA_DIRECTORY GlobalPtr;
			[FieldOffset(168)]
			public IMAGE_DATA_DIRECTORY TLSTable;
			[FieldOffset(176)]
			public IMAGE_DATA_DIRECTORY LoadConfigTable;
			[FieldOffset(184)]
			public IMAGE_DATA_DIRECTORY BoundImport;
			[FieldOffset(192)]
			public IMAGE_DATA_DIRECTORY IAT;
			[FieldOffset(200)]
			public IMAGE_DATA_DIRECTORY DelayImportDescriptor;
			[FieldOffset(208)]
			public IMAGE_DATA_DIRECTORY CLRRuntimeHeader;
			[FieldOffset(216)]
			public IMAGE_DATA_DIRECTORY Reserved;
		}

		[StructLayout(LayoutKind.Explicit)]
		public struct IMAGE_NT_HEADERS32
		{
			[FieldOffset(0)]
			[MarshalAs(UnmanagedType.ByValArray, SizeConst = 4)]
			public char[] Signature;
			[FieldOffset(24)]
			public IMAGE_OPTIONAL_HEADER32 OptionalHeader;

			public bool IsValid => new string(Signature) == "PE\0\0";
		}

		[StructLayout(LayoutKind.Explicit)]
		public struct IMAGE_OPTIONAL_HEADER64
		{
			[FieldOffset(0)]
			public ushort Magic;
			[FieldOffset(2)]
			public byte MajorLinkerVersion;
			[FieldOffset(3)]
			public byte MinorLinkerVersion;
			[FieldOffset(4)]
			public uint SizeOfCode;
			[FieldOffset(8)]
			public uint SizeOfInitializedData;
			[FieldOffset(12)]
			public uint SizeOfUninitializedData;
			[FieldOffset(16)]
			public uint AddressOfEntryPoint;
			[FieldOffset(20)]
			public uint BaseOfCode;
			[FieldOffset(24)]
			public ulong ImageBase;
			[FieldOffset(32)]
			public uint SectionAlignment;
			[FieldOffset(36)]
			public uint FileAlignment;
			[FieldOffset(40)]
			public ushort MajorOperatingSystemVersion;
			[FieldOffset(42)]
			public ushort MinorOperatingSystemVersion;
			[FieldOffset(44)]
			public ushort MajorImageVersion;
			[FieldOffset(46)]
			public ushort MinorImageVersion;
			[FieldOffset(48)]
			public ushort MajorSubsystemVersion;
			[FieldOffset(50)]
			public ushort MinorSubsystemVersion;
			[FieldOffset(52)]
			public uint Win32VersionValue;
			[FieldOffset(56)]
			public uint SizeOfImage;
			[FieldOffset(60)]
			public uint SizeOfHeaders;
			[FieldOffset(64)]
			public uint CheckSum;
			[FieldOffset(68)]
			public ushort Subsystem;
			[FieldOffset(70)]
			public ushort DllCharacteristics;
			[FieldOffset(72)]
			public ulong SizeOfStackReserve;
			[FieldOffset(80)]
			public ulong SizeOfStackCommit;
			[FieldOffset(88)]
			public ulong SizeOfHeapReserve;
			[FieldOffset(96)]
			public ulong SizeOfHeapCommit;
			[FieldOffset(104)]
			public uint LoaderFlags;
			[FieldOffset(108)]
			public uint NumberOfRvaAndSizes;
			[FieldOffset(112)]
			public IMAGE_DATA_DIRECTORY ExportTable;
			[FieldOffset(120)]
			public IMAGE_DATA_DIRECTORY ImportTable;
			[FieldOffset(128)]
			public IMAGE_DATA_DIRECTORY ResourceTable;
			[FieldOffset(136)]
			public IMAGE_DATA_DIRECTORY ExceptionTable;
			[FieldOffset(144)]
			public IMAGE_DATA_DIRECTORY CertificateTable;
			[FieldOffset(152)]
			public IMAGE_DATA_DIRECTORY BaseRelocationTable;
			[FieldOffset(160)]
			public IMAGE_DATA_DIRECTORY Debug;
			[FieldOffset(168)]
			public IMAGE_DATA_DIRECTORY Architecture;
			[FieldOffset(176)]
			public IMAGE_DATA_DIRECTORY GlobalPtr;
			[FieldOffset(184)]
			public IMAGE_DATA_DIRECTORY TLSTable;
			[FieldOffset(192)]
			public IMAGE_DATA_DIRECTORY LoadConfigTable;
			[FieldOffset(200)]
			public IMAGE_DATA_DIRECTORY BoundImport;
			[FieldOffset(208)]
			public IMAGE_DATA_DIRECTORY IAT;
			[FieldOffset(216)]
			public IMAGE_DATA_DIRECTORY DelayImportDescriptor;
			[FieldOffset(224)]
			public IMAGE_DATA_DIRECTORY CLRRuntimeHeader;
			[FieldOffset(232)]
			public IMAGE_DATA_DIRECTORY Reserved;
		}

		[StructLayout(LayoutKind.Explicit)]
		public struct IMAGE_NT_HEADERS64
		{
			[FieldOffset(0)]
			[MarshalAs(UnmanagedType.ByValArray, SizeConst = 4)]
			public char[] Signature;
			[FieldOffset(24)]
			public IMAGE_OPTIONAL_HEADER64 OptionalHeader;

			public bool IsValid => new string(Signature) == "PE\0\0";
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
		internal enum LoadLibraryFlags : uint
		{
			DONT_RESOLVE_DLL_REFERENCES = 0x00000001,
		}

		[DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
		internal static extern IntPtr LoadLibraryEx(string lpFileName, IntPtr hReservedNull, LoadLibraryFlags dwFlags);

		[DllImport("kernel32.dll", SetLastError = true)]
		[return: MarshalAs(UnmanagedType.Bool)]
		internal static extern bool FreeLibrary(IntPtr hModule);

		[DllImport("Kernel32.dll", CharSet = CharSet.Unicode)]
		internal static extern IntPtr GetProcAddress(IntPtr hModule, string procName);

		[DllImport("kernel32.dll")]
		internal static extern int GetLastError();

	}
}
