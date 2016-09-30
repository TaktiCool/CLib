class CLib_baseFNC {
    preInit = 0;
    postInit = 0;
    preStart = 0;
    #ifdef isDev
        recompile = 1;
    #else
        recompile = 0;
    #endif
};

class CLib_basePreFNC: CLib_baseFNC {
    preInit = 1;
};

class CLib_basePreStartFNC: CLib_baseFNC {
    preStart = 1;
};

class CLib_basePostFNC: CLib_baseFNC {
    postInit = 1;
};

class CLib_basePreInitStartFNC: CLib_baseFNC {
    preStart = 1;
    preInit = 1;
};

class cfgFunctions {

    createShortcuts = 1;

    //init = "pr\CLib\addons\CLib\init.sqf";
    class CLib {
        class CLib {
            file = "\pr\CLib\addons\CLib\Core";
            class preInit: CLib_basePreFNC {};
            class preStart: CLib_basePreStartFNC {};
            class postInit: CLib_basePostFNC {};
        };
    };
};
