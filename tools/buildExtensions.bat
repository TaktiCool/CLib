call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat"
MSbuild "..\extensions\CLib\CLib.sln" /p:Configuration=Release /p:Platform=x64
MSbuild "..\extensions\CLib\CLib.sln" /p:Configuration=Release /p:Platform=x86

Pause