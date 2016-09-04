#include "macros.hpp"

if (isNil QFUNC(compile)|| isNil QFUNC(compressString) || isNil QFUNC(decompressString) || isNil QFUNC(stripSqf)) then {
    DFUNC(compile) = compile preprocessFileLineNumbers QUOTE(FUNCPATH(compile));
    DFUNC(compressString) = compile preprocessFileLineNumbers QUOTE(FUNCPATH(compressString));
    DFUNC(decompressString) = compile preprocessFileLineNumbers QUOTE(FUNCPATH(decompressString));
    DFUNC(stripSqf) = compile preprocessFileLineNumbers QUOTE(FUNCPATH(stripSqf));
};

#include "PREP.hpp"
