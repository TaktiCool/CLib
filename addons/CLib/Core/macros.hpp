#define MODULE Core
#include "\pr\CLib\addons\CLib\CLib_Macros.hpp"

#ifdef isDev
    #define cmp compile
#else
    #define cmp compileFinal
#endif
