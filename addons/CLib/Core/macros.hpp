#define MODULE Core
#include "\tc\CLib\addons\CLib\CLib_Macros.hpp"

#ifdef ISDEV
    #define CMP compile
#else
    #define CMP compileFinal
#endif
