#include "CLib_Macros.hpp"
class CfgPatches {
    class CLib {
        name = "CLib - Community Libary";
        units[] = {};
        weapons[] = {};
        requiredVersion = 2.02;
        author = "CLib Team";
        authors[] = {"joko // Jonas", "NetFusion", "BadGuy"};
        authorUrl = "https://takticool.github.io/CLib/";
        version = VERSION;
        versionStr = QUOTE(VERSION);
        versionAr[] = {VERSION_AR};
        requiredAddons[] = {"A3_Data_F_Oldman_Loadorder", "A3_Data_F_Mod_Loadorder"};
    };
};

#include "cfgFunctions.hpp"

#include "cfgCLibLocalization.hpp"

#include "cfgCLibModules.hpp"

#include "Gear\Loadout\CfgCLibLoadouts.hpp"

#ifdef ISDEV
    #include "Settings\CfgCLibSettings.hpp"
    #include "SimpleObjectFramework\CfgCLibSimpleObject.hpp"
#endif
