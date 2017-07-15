#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:


    Parameter(s):


    Returns:

*/
params ["_hashSet", "_value"];

_value in (_hashSet select HASH_KEY);
