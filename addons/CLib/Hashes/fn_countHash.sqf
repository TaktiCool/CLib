#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Counts amount of Hashes in Hash set

    Parameter(s):
    0: HashSet <Array>

    Returns:
    Amount of Hashes in Hashset <Number>
*/
params ["_hashSet"];

count (_hashSet select HASH_KEY);
