#define MODULE InitFunctions
#include "\tc\CLib\addons\CLib\CLib_Macros.hpp"
#ifdef ISDEV
    #undef RUNTIMESTART
    #undef RUNTIME
    #define RUNTIMESTART private _debugStartTime = diag_tickTime
    #define RUNTIME(var) DUMP(var + " Needed: " + (str (diag_tickTime - _debugStartTime)) + " ms")
#endif
