#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Delete a Location

    Parameter(s):
    0: Namespace <Location, Object> (Default: locationNull)

    Returns:
    None
*/

params [
    ["_namespace", locationNull, [locationNull, objNull]]
];

GVAR(allCustomNamespaces) deleteAt (GVAR(allCustomNamespaces) find _namespace);

if (_namespace isEqualType locationNull) then {
    deleteLocation _namespace;
} else {
    deleteVehicle _namespace;
};

nil
