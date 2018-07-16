call "D:\Programme\VisualStudio\VC\Auxiliary\Build\vcvars64.bat"
MSbuild "..\extensions\CLib\CLib.sln" /p:Configuration=Release /p:Platform=x64 /maxcpucount
MSbuild "..\extensions\CLib\CLib.sln" /p:Configuration=Release /p:Platform=x86 /maxcpucount

Pause