#define MODULE Localisation
#include "\tc\CLib\addons\CLib\CLib_Macros.hpp"

#ifdef DISABLECOMPRESSION
    #define USECOMPRESSION false
#else
    #define USECOMPRESSION GVAR(useFunctionCompression)
#endif
