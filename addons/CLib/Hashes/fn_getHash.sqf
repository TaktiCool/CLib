#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:


    Parameter(s):


    Returns:

*/
params ["_hash", "_key"];

private _i = (_hash select HASH_KEY) find _key;

(_hash select HASH_VALUE) select _i;
