#define DFNC(f) class f
#define FNC(f) DFNC(f)
#define APIFNC(f) DFNC(f) {api = 1;}
#define MODULE(m) class m

class ClibBaseFunction;
class ClibBaseModule;


class CfgClibModules {
    /*
    class PRA3 {
        path = "\pr\PRA3\addons\PRA3_Server"; // TODO add Simplifyed Macro for this
        class Module1 {
            dependency[] = {}; // the Module that is Required for using this Module
            class fnc1 { // first Function
                api = 1; // Function is safed without Module in the Function name PRA3_fnc_fnc1
                onlyServer = 1; // Function that dont get Brodcasted over the network
            };
            class fnc2 {}; // Name: PRA3_Module1_fnc_fnc2 Path: "\pr\PRA3\addons\PRA3_Server\Module1\fn_fnc2.sqf"
            class init { // init get executed on every client
                priority = 10; // than higer the prio than earlier the function gets executed. if a function have the same prio the function gets executed in the order they get added
            };
            class clientInit { // only execute on hasInterface
                priority = 10; // Same as in init
            };
            class serverInit { // only execute on isServer
                priority = 10; // Same as in init
            };
            class postInit { // execute on every client AFTER 1 Frame after the other Inits are done
                priority = 10; // Same as in init
            };

            class Module2 { // this is a Sub Module of Module1
                class fnc3 {}; // Name: PRA3_Module1_fnc_fnc3 Path: "\pr\PRA3\addons\PRA3_Server\Module1\Module2\fn_fnc2.sqf"
            };
        };
    };
    */
    class Clib {
        path = "\pr\Clib\addons\Clib";

        MODULE(PerFrame) {
            APIFNC(addPerframeHandler);
            APIFNC(execNextFrame);
            FNC(init);
            APIFNC(removePerframeHandler);
            APIFNC(wait);
            APIFNC(waitUnil);
        };

        MODULE(Events) {
            APIFNC(addEventHandler);
            APIFNC(addIgnoredEventLog);
            FNC(clientInit);
            APIFNC(globalEvent);
            FNC(hcInit);
            FNC(init);
            APIFNC(localEvent);
            APIFNC(removeEventhandler);
            APIFNC(serverEvent);
            FNC(servetInit);
            APIFNC(targetEvent);
        };

        MODULE(Localisation) {
            FNC(initLocalisation);
            APIFNC(isLocalised);
            APIFNC(readLocalisation);
        };

        MODULE(Autoload) {
            APIFNC(autoloadEntryPoint);
            APIFNC(callModules);
            APIFNC(loadModules);
            APIFNC(sendFunctions);
            APIFNC(sendFunctionsLoop);
        };

        MODULE(ConfigCaching) {
            APIFNC(configProperties);
            FNC(init);
            APIFNC(returnParents);
        };

        MODULE(3dGraphics) {
            APIFNC(3dGraphicsPosition);
            APIFNC(add3dGraphics);
            APIFNC(build3dGraphicsCache);
            FNC(clientInit);
            APIFNC(draw3dGraphics);
            APIFNC(remove3dGraphics);
        };

        MODULE(extensionFramework) {
            APIFNC(callExtension);
            FNC(init);
            APIFNC(remoteCallExtension);
            APIFNC(splitOutputString);
        };
        MODULE(Gear) {
            APIFNC(addContainer);
            APIFNC(addItem);
            APIFNC(addMagazine);
            APIFNC(addWeapon);
            APIFNC(copyGear);
            APIFNC(getAllGear);
            APIFNC(restoreGear);
            APIFNC(saveGear);
        };
        MODULE(Interaction) {
            APIFNC(addAction);
            APIFNC(addCanInteractWith);
            APIFNC(addHoldAction);
            APIFNC(canInteractWith);
            FNC(clientInitCanInteractWith);
            FNC(clientInitInteraction);
            APIFNC(holdActionCallback);
            APIFNC(inRange);
            APIFNC(loop);
            APIFNC(overrideAction);
        };
        MODULE(lnbData) {
            FNC(initlnbData);
            APIFNC(lnbLoad);
            APIFNC(lnbSave);
        };

        MODULE(MapGraphics) {
            APIFNC(addMapGraphicsEventHandler);
            APIFNC(addMapGraphicsGroup);
            APIFNC(buildMapGraphicsCache);
            FNC(clientInit);
            APIFNC(drawMapGraphics);
            APIFNC(mapGraphicsMouseButtionClick);
            APIFNC(mapGraphicsMouseMoving);
            APIFNC(mapGraphicsPosition);
            APIFNC(removeMapGraphicsEventhandler);
            APIFNC(removeMapGraphicsGroup);
            APIFNC(TriggerMapGraphicsEvent);
            APIFNC(registerMapControl);
            APIFNC(unregisterMapControl);
        };
        MODULE(Misc) {
            APIFNC(addPerformanceCounter);
            APIFNC(blurScreen);
            APIFNC(cachedCall);
            APIFNC(codeToString);
            APIFNC(createPPEffects);
            APIFNC(deleteAtEntry);
            APIFNC(directCall);
            APIFNC(disableUserInput);
            APIFNC(findSavePosition);
            APIFNC(fixFloating);
            APIFNC(fixPosition);
            APIFNC(getFOV);
            APIFNC(gearNearUnits);
            APIFNC(groupPlayers);
            FNC(init);
            APIFNC(name);
            APIFNC(sanitizeString);
            FNC(serverInit);
            APIFNC(setVariablePublic);
        };
        MODULE(Mutex) {
            FNC(clientInit);
            APIFNC(mutex);
            FNC(serverInit);
        };
        MODULE(Namespaces) {
            APIFNC(allVariables);
            APIFNC(createNamespace);
            APIFNC(deleteNamespace);
            APIFNC(getLogicGroup);
            APIFNC(getVariable);
            APIFNC(setVar);
            APIFNC(setVariable);
        };
        MODULE(RemoteExecution) {
            APIFNC(execute);
            APIFNC(handleIncomeData);
            APIFNC(remoteExec);
            APIFNC(serverInit);
        };
        MODULE(Statemachine) {
            APIFNC(addStatemachineState);
            APIFNC(copyStatemachine);
            APIFNC(createStatemachine);
            APIFNC(createStatemachineFromConfig);
            APIFNC(getVariableStatemachine);
            FNC(init);
            APIFNC(setVariableStatemachine);
            APIFNC(startStatemachine);
            APIFNC(stepStatemachine);
        };
        MODULE(StatusEffects) {
            APIFNC(addStatusEffectType);
            FNC(init);
            APIFNC(setStatusEffect);
        };
    };
};
