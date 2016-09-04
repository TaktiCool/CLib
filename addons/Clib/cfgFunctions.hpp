class baseFNC {
    preInit = 0;
    postInit = 0;
    preStart = 0;
    #ifdef isDev
        recompile = 1;
    #else
        recompile = 0;
    #endif
};

class basePreFNC: baseFNC {
    preInit = 1;
};

class basePreStartFNC: baseFNC {
    preStart = 1;
};

class cfgFunctions {

    createShortcuts = 1;

    //init = "x\Clib\addons\Clib\init.sqf";
    class Clib {
        class Clib_Core {
            file = ;
        };
    };
};
