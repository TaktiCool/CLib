// Check Debug settings
#ifdef DEBUGFULL
    #define ISDEV
    #define ENABLEPERFORMANCECOUNTER
    #define ENABLEFUNCTIONTRACE
#endif

#ifdef DEBUGFULL
    #undef DISABLECOMPRESSION
#endif

// Predefines for easy Macro work
#define DOUBLE(var1,var2) var1##_##var2
#define TRIPLE(var1,var2,var3) DOUBLE(var1,DOUBLE(var2,var3))

#define QUOTE(var) #var

#define FUNCPATH(var) \##PATH\##PREFIX\addons\##MOD\##MODULE\fn_##var.sqf
#define FFNCPATH(subModule,var) \##PATH\##PREFIX\addons\##MOD\##MODULE\##subModule\fn_##var.sqf

// Global Varible Macros
#define EGVAR(var1,var2) TRIPLE(PREFIX,var1,var2)
#define QEGVAR(var1,var2) QUOTE(EGVAR(var1,var2))

#define GVAR(var) EGVAR(MODULE,var)
#define QGVAR(var) QUOTE(GVAR(var))

#define CGVAR(var) DOUBLE(CLib,var)
#define QCGVAR(var) QUOTE(CGVAR(var))

#define UIVAR(var1) QEGVAR(UI,var1)

#define SYSLOGGING(var1,var2) isNil {\
    if (isNil "CLib_fnc_log") then {\
        private _CLib_loggingVar = format ["(%1) [%2 %3 - %4]: %5 %6:%7", diag_frameNo, QUOTE(PREFIX), var1, QUOTE(MODULE), var2, __FILE__, __LINE__];\
        diag_log text _CLib_loggingVar;\
    } else {\
        [var1 ,QUOTE(PREFIX), QUOTE(MODULE), var2, __FILE__, __LINE__, _fnc_scriptName, _fnc_scriptNameParent, _fnc_scriptMap] call CLib_fnc_log;\
    };\
};

// Logging/Dumping macros
#ifdef ISDEV
    #define DUMP(var) SYSLOGGING("DUMP", var)
#else
    #define DUMP(var) /* disabled */
#endif

#define LOG(var) SYSLOGGING("Log", var)


// Function macros
#define EDFUNC(var1,var2) TRIPLE(PREFIX,var1,DOUBLE(fnc,var2))

#define DFUNC(var) EDFUNC(MODULE,var)

#define QEFUNC(var1,var2) QUOTE(EDFUNC(var1,var2))

#define QFUNC(var) QUOTE(DFUNC(var))

#ifdef ISDEV
    #define EFUNC(var1,var2) (currentNamespace getVariable [QEFUNC(var1,var2), {if (time > 0) then {["Error function %1 dont exist or isNil in %2 L%3", QEFUNC(var1,var2), __FILE__, __LINE__] call BIS_fnc_errorMsg;}; DUMP(QEFUNC(var1,var2) + " Dont Exist")}])
#endif

#ifdef ENABLEFUNCTIONTRACE
    #undef EFUNC
    #define EFUNC(var1,var2) {\
        DUMP("Function " + QEFUNC(var1,var2) + " called with " + str (_this));\
        private _tempRet = _this call (currentNamespace getVariable [QEFUNC(var1,var2), {if (time > 0) then {["Error function %1 dont exist or isNil in %2 L%3", QEFUNC(var1,var2), __FILE__, __LINE__] call BIS_fnc_errorMsg;}; DUMP(QEFUNC(var1,var2) + " Dont Exist")}]);\
        if (!isNil "_tempRet") then {\
            _tempRet\
        }\
    }
#endif

#ifndef EFUNC
    #define EFUNC(var1,var2) EDFUNC(var1,var2)
#endif

#define FUNC(var) EFUNC(MODULE,var)

#define DCFUNC(var) TRIPLE(CLib,fnc,var)
#define QCFUNC(var) QUOTE(DCFUNC(var))

#ifdef ISDEV
    #define CFUNC(var) (currentNamespace getVariable [QCFUNC(var), {if (time > 0) then {["Error function %1 dont exist or isNil", QCFUNC(var)] call BIS_fnc_errorMsg;}; DUMP(QCFUNC(var) + " Dont Exist")}])
#else
    #define CFUNC(var) DCFUNC(var)
#endif

// #define PREP(fncName) [QUOTE(FUNCPATH(fncName)), QFUNC(fncName)] call CFUNC(compile);
// #define EPREP(folder,fncName) [QUOTE(FFNCPATH(folder,fncName)), QFUNC(fncName)] call CFUNC(compile);

#include "supportMacros.hpp"
