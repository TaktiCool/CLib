#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Call a Extension from the Client to the Server
    After the server Finish the call the extension and getting the result the server tranfer the Retunred value to the client
    and calling on the Client the attached Function

    Parameter(s):
    0: Action <String>
    1: Data <String> (default: "")
    2: Function <Code, String>
    3: Function Arguments <Any> (default: nil)

    Returns:
    None
*/
["extensionRequest", [_this, CLib_Player]] call CFUNC(serverEvent);
