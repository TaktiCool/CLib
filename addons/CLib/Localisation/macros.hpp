#define MODULE Localisation
#include "\pr\CLib\addons\CLib\CLib_Macros.hpp"

#ifdef disableCompression
    #define useCompression false
#else
    #define useCompression GVAR(useFunctionCompression)
#endif
