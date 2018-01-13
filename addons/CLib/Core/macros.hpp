#define MODULE Core
#include "\tc\CLib\addons\CLib\CLib_Macros.hpp"

#ifdef ISDEV
    #define CMP(var) compile var
#else
    #define CMP(var) compileFinal var
#endif
