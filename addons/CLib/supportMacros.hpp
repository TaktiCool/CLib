
// define Version Information
#define VERSION MAJOR.MINOR.PATCHLVL.BUILD
#define VERSION_AR MAJOR,MINOR,PATCHLVL,BUILD

// is Data Type Check of easyer Code reading
#define IS_ARRAY(var) var isEqualType []
#define IS_BOOL(var) var isEqualType false
#define IS_CODE(var) var isEqualType {}
#define IS_CONFIG(var) var isEqualType configNull
#define IS_CONTROL(var) var isEqualType controlNull
#define IS_DISPLAY(var) var isEqualType displayNull
#define IS_GROUP(var) var isEqualType grpNull
#define IS_OBJECT(var) var isEqualType objNull
#define IS_SCALAR(var) var isEqualType 0
#define IS_SCRIPT(var) var isEqualType scriptNull
#define IS_SIDE(var) var isEqualType west
#define IS_STRING(var) var isEqualType "STRING"
#define IS_TEXT(var) var isEqualType text ""
#define IS_LOCATION(var) var isEqualType locationNull
#define IS_INTEGER(var)  if ( IS_SCALAR(var) ) then { (floor(var) == (var)) } else { false }
#define IS_NUMBER(var)   IS_SCALAR(var)

// is Voted Admin Server (not 100% supported the Server Owner can change the comands what the voted Admin can use)
#define IS_ADMIN ((call BIS_fnc_admin) isEqualTo 1)
// is Logged Admin Server (not 100% supported the Server Owner can change the comands what the voted Admin can use)
#define IS_ADMIN_LOGGED ((call BIS_fnc_admin) isEqualTo 2)

// Deprecated System for Functions
#define DEPRECATEFUNC(OLD_FUNC,NEW_FUNC) \
    OLD_FUNC = { \
        LOG('Deprecated function used: OLD_FUNC (new: NEW_FUNC) in PREFIX'); \
        if (isNil "_this") then { call NEW_FUNC } else { _this call NEW_FUNC }; \
    }

#define REPLACEDFUNC(OLD_FUNC,NEW_FUNC,VERSION) \
    LOG('OLD_FUNC gets Replace with NEWFUNC in VERSION')

// UI Based Macros
#define PYN 108
#define PX(X) ((X)/PYN*safeZoneH/(4/3))
#define PY(Y) ((Y)/PYN*safeZoneH)

// QPREFIX
#define QPREFIX QUOTE(PREFIX)

// CFG Function Macro for Easy Module Including
#define FUNCTIONSCONFIG(moduleName) class DOUBLE(PREFIX,moduleName) { \
    class moduleName { \
        file = QUOTE(\PATH\PREFIX\addons\MOD\##moduleName); \
        class preInit: basePreFNC {}; \
        class preStart: basePreStartFNC {}; \
    }; \
};

#define singleFunctionConfig(Module,func,baseClass) class func : baseClass {file = QUOTE(\PATH\PREFIX\addons\MOD\##Module##\fn_##func##.sqf);};
#define singleFunctionConfigSub(Module,submodule,func,baseClass) class func : baseClass {file = QUOTE(\PATH\PREFIX\addons\MOD\##Module##\##submodule##\fn_##func##.sqf);};

#ifdef ENABLEPERFORMANCECOUNTER
    #define RUNTIMESTART private _CLib_Debug_debugStartTime = diag_tickTime
    #define RUNTIME(var) DUMP(var + " Needed: " + ((diag_tickTime - _CLib_Debug_debugStartTime) call CFUNC(toFixedNumber)) + " ms")
#else
    #define RUNTIMESTART /*Disabled*/
    #define RUNTIME(var) /*Disabled*/
#endif

#define ELSTRING(var1,var2) TRIPLE(DOUBLE(STR,PREFIX),var1,var2)
#define LSTRING(var) ELSTRING(MODULE,var)

#define QLSTRING(var) QUOTE(LSTRING(var))
#define QELSTRING(var1,var2) QUOTE(ELSTRING(var1,var2))

#define LOC(var) var call CFUNC(readLocalisation)
#define MLOC(var) LOC(QLSTRING(var))

#define EXEC_ONLY_UNSCHEDULED if (canSuspend) exitWith { LOG("WARNING: " + _fnc_scriptName + " was called in SCHEDULED Enviroment from "+ _fnc_scriptNameParent); [missionNamespace getVariable _fnc_scriptName, _this] call CFUNC(directCall);}
#define EXEC_ONLY_IN_NAMESPACE(var) if !(currentNamespace isEqualTo var) exitWith { with var do {LOG("WARNING: " + _fnc_scriptName + " was called in the wrong Namespace from "+ _fnc_scriptNameParent); _this call (var getVariable _fnc_scriptName);}
#define EXEC_ONLY_IN_MISSIONNAMESPACE EXEC_ONLY_IN_NAMESPACE(missionNamespace)

#ifdef DISABLECOMPRESSION
    #define USE_COMPRESSION(var) false
#else
    #define USE_COMPRESSION(var) var && (!isNil QCGVAR(useCompression) && {CGVAR(useCompression)})
#endif

#define SCRIPTSCOPENAME (_fnc_scriptName + "_Main")
#define FUNCTIONNAME _fnc_scriptName

#define RELDIR(pos1,pos2) (((pos1 getRelDir pos2) + 180) % 360 - 180)
