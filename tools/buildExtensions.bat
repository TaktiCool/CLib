
call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat"


:Que
echo Debug 0
echo Release 1


set /p choice="Please Select one of the above options :"

IF %choice% GEQ 2 (
echo Build Type %BUILD% is not supported
GOTO :Que
)

IF %choice% EQU 1 (
set BUILD=Release
) ELSE (
set BUILD=Debug
)

cd "..\extensions\CLib"
nuget restore
MSbuild "CLib.sln" /p:Configuration=%BUILD% /p:Platform=x64
MSbuild "CLib.sln" /p:Configuration=%BUILD% /p:Platform=x86

Pause
