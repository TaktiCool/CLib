#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Very dirty solution to check if a file exists. Every file type need to be added at allowedHTMLLoadExtensions in the server config file.

    Parameter(s):
    0: File Path with Filename <String>

    Returns:
    File exist? <Bool>
*/
params [["_file", "", [""]]];
private _ctrl = (findDisplay 0) ctrlCreate ["RscHTML", -1];
_ctrl htmlLoad _file;
private _return = ctrlHTMLLoaded _ctrl;
ctrlDelete _ctrl;
_return;
