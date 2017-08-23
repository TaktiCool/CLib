#include "macros.hpp"
/*
    Community Lib - CLib

    Author: NetFusion

    Description:
    PreStart

    Parameter(s):
    None

    Returns:
    None
*/

// Communication control
GVAR(SOH) = toString [1];
GVAR(STX) = toString [2];
GVAR(ETX) = toString [3];
GVAR(EOT) = toString [4];
GVAR(ENQ) = toString [5];
GVAR(ACK) = toString [6];

// Information separators
GVAR(RS) = toString [30];
GVAR(US) = toString [31];

// Replacement character
GVAR(RC) = toString [65533];
if (isNil QFUNC(extensionFetch)) then {
    DFUNC(extensionFetch) = compile preprocessFileLineNumbers "\tc\CLib\addons\CLib\Core\ExtensionFramework\fn_extensionFetch.sqf";
};
if (isNil QFUNC(extensionRequest)) then {
    DFUNC(extensionRequest) = compile preprocessFileLineNumbers "\tc\CLib\addons\CLib\Core\ExtensionFramework\fn_extensionRequest.sqf";
};
