#include "macros.hpp"

if (isNil QFUNC(compile)|| isNil QFUNC(compressString) || isNil QFUNC(decompressString) || isNil QFUNC(stripSqf)) then {
    DCFUNC(compile) = compile preprocessFileLineNumbers QUOTE(FUNCPATH(compile));
    DCFUNC(compressString) = compile preprocessFileLineNumbers QUOTE(FUNCPATH(compressString));
    DCFUNC(decompressString) = compile preprocessFileLineNumbers QUOTE(FUNCPATH(decompressString));
    DCFUNC(stripSqf) = compile preprocessFileLineNumbers QUOTE(FUNCPATH(stripSqf));
};

// The autoloader uses this array to get all function names.
GVAR(functionCache) = [];
call CFUNC(readAllModulesAndFunctions);
