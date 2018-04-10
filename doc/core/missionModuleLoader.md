# Mission Module Loader

> Maintainer: joko // Jonas, NetFusion

The Mission Module Loader is a Module where you are able to use a CLib Entry Point from the mission side.

The Script files are Required to be called fn_functionName.sqf in the folder CLibModules/MODULE.  
Sub Modules and Dependency's are not Supported!  
Supported Entry Points are init(all clients and server), serverInit(isServer), clientInit(hasInterface), hcInit(not hasInterface and not isServer).  
All Mission Modules are always loaded.
All CLib Modules are available at the point of calling.
## Mission Side Implementation
Examples:
```sqf
class CLib {
    class CfgCLibMissionModules {
        tag = "Test";
        class testModule {
            class clientInit;
            class hcInit;
            class init;
            class serverInit;
            class testFnc;
        };
    };
};
```

[`<Control>`]: https://community.bistudio.com/wiki/Control
[`<Anything>`]: https://community.bistudio.com/wiki/Anything
[`<Config>`]: https://community.bistudio.com/wiki/Config
[`<Object>`]: https://community.bistudio.com/wiki/Object
[`<String>`]: https://community.bistudio.com/wiki/String
[`<Number>`]: https://community.bistudio.com/wiki/Number
[`<Array>`]: https://community.bistudio.com/wiki/Array
[`<Position>`]: https://community.bistudio.com/wiki/Position
[`<Color>`]: https://community.bistudio.com/wiki/Color
[`<Boolean>`]: https://community.bistudio.com/wiki/Boolean
[`<Code>`]: https://community.bistudio.com/wiki/Code
[`<Group>`]: https://community.bistudio.com/wiki/Group
