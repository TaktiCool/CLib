#define MODULE Core
#include "\tc\CLib\addons\CLib\CLib_Macros.hpp"

#ifdef isDev
    #define cmp compile
#else
    #define cmp compileFinal
#endif
