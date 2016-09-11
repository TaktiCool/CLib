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

    //init = "pr\CLib\addons\CLib\init.sqf";
    class CLib {
        class CLib {
            file = "\pr\CLib\addons\CLib\Compile";
            class compileAllFunctions: baseFNC {};
            class readAllModulesAndFunctions: baseFNC {};
            class checkAllFunctionCompression: baseFNC {};
            class checkCompression: baseFNC {};
            class compile: baseFNC {};
            class compressString: baseFNC {};
            class decompressString: baseFNC {};
            class stripSqf: baseFNC {};
            class preInit: basePreFNC {};
            class preStart: basePreStartFNC {};
        };
    };
};
