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

class CLib_basePreInitStartFNC: CLib_baseFNC {
    preStart = 1;
    preInit = 1;
};

class cfgFunctions {

    createShortcuts = 1;

    //init = "pr\CLib\addons\CLib\init.sqf";
    class CLib {
        class CLib {
            file = "\pr\CLib\addons\CLib\Compile";
            class compileAllFunctions: CLib_baseFNC {};
            class readAllModulesAndFunctions: CLib_baseFNC {};
            class checkAllFunctionCompression: CLib_baseFNC {};
            class checkCompression: CLib_baseFNC {};
            class compile: CLib_baseFNC {};
            class compressString: CLib_baseFNC {};
            class decompressString: CLib_baseFNC {};
            class stripSqf: CLib_baseFNC {};
            class preInit: CLib_basePreFNC {};
            class preStart: CLib_basePreStartFNC {};
        };
    };
};
