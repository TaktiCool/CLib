
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
#define IS_ADMIN serverCommandAvailable "#kick"
// is Logged Admin Server (not 100% supported the Server Owner can change the comands what the voted Admin can use)
#define IS_ADMIN_LOGGED serverCommandAvailable "#shutdown"

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
    #define PERFORMANCECOUNTER_START(var1) [#var1, true] call CFUNC(addPerformanceCounter);
    #define PERFORMANCECOUNTER_END(var1) [#var1, false] call CFUNC(addPerformanceCounter);
#else
    #define PERFORMANCECOUNTER_START(var1) /* Performance Counter disabled */
    #define PERFORMANCECOUNTER_END(var1) /* Performance Counter disabled */
#endif

#define ELSTRING(var1,var2) TRIPLE(DOUBLE(STR,PREFIX),var1,var2)
#define LSTRING(var) ELSTRING(MODULE,var)

#define QLSTRING(var) QUOTE(LSTRING(var))
#define QELSTRING(var1,var2) QUOTE(ELSTRING(var1,var2))

#define LOC(var) var call CFUNC(readLocalisation)

#define MLOC(var) LOC(QLSTRING(var))
