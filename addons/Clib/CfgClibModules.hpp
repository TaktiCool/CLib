#define DFNC(f) class f
#define FNC(f) DFNC(f) {}
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

        MODULE(3dGraphics) {
            AFNC(3dGraphicsPosition);
            AFNC(add3dGraphics);
            AFNC(build3dGraphicsCache);
            FNC(clientInit3dGraphics);
            AFNC(draw3dGraphics);
            AFNC(remove3dGraphics);
        };
        MODULE(Autoload) {
            AFNC(autoloadEntryPoint);
            AFNC(callModules);
            AFNC(loadModules);
            AFNC(sendFunctions);
            AFNC(sendFunctionsLoop);
        };
        MODULE(ConfigCaching) {
            AFNC(configProperties);
            FNC(initConfigCaching);
            AFNC(returnParents);
        };
        MODULE(Events) {
            AFNC(addEventHandler);
            AFNC(addIgnoredEventLog);
            FNC(clientInitEvents);
            AFNC(globalEvent);
            FNC(hcInitEvents);
            FNC(initEvents);
            AFNC(localEvent);
            AFNC(removeEventhandler);
            AFNC(serverEvent);
            FNC(servetInitEvents);
            AFNC(targetEvent);
        };
        MODULE(extensionFramework) {
            AFNC(callExtension);
            FNC(init);
            AFNC(remoteCallExtension);
            AFNC(splitOutputString);
        };
        MODULE(Gear) {
            AFNC(addContainer);
            AFNC(addItem);
            AFNC(addMagazine);
            AFNC(addWeapon);
            AFNC(copyGear);
            AFNC(getAllGear);
            AFNC(restoreGear);
            AFNC(saveGear);
        };
        MODULE(Interaction) {
            AFNC(addAction);
            AFNC(addCanInteractWith);
            AFNC(addHoldAction);
            AFNC(canInteractWith);
            FNC(clientInitCanInteractWith);
            FNC(clientInitInteraction);
            AFNC(holdActionCallback);
            AFNC(inRange);
            AFNC(loop);
            AFNC(overrideAction);
        };
        MODULE(lnbData) {
            FNC(initlnbData);
            AFNC(lnbLoad);
            AFNC(lnbSave);
        };
        MODULE(Localisation) {
            FNC(initLocalisation);
            AFNC(isLocalised);
            AFNC(readLocalisation);
        };
        MODULE(MapGraphics) {
            AFNC(addMapGraphicsEventHandler);
            AFNC(addMapGraphicsGroup);
            AFNC(buildMapGraphicsCache);
            FNC(clientInitMapGraphics);
            AFNC(drawMapGraphics);
            AFNC(mapGraphicsMouseButtionClick);
            AFNC(mapGraphicsMouseMoving);
            AFNC(mapGraphicsPosition);
            AFNC(removeMapGraphicsEventhandler);
            AFNC(removeMapGraphicsGroup);
            AFNC(TriggerMapGraphicsEvent);
            AFNC(registerMapControl);
            AFNC(unregisterMapControl);
        };
        MODULE(Misc) {
            AFNC(addPerformanceCounter);
            AFNC(blurScreen);
            AFNC(cachedCall);
            AFNC(codeToString);
            AFNC(createPPEffects);
            AFNC(deleteAtEntry);
            AFNC(directCall);
            AFNC(disableUserInput);
            AFNC(findSavePosition);
            AFNC(fixFloating);
            AFNC(fixPosition);
            AFNC(getFOV);
            AFNC(gearNearUnits);
            AFNC(groupPlayers);
            FNC(init);
            AFNC(name);
            AFNC(sanitizeString);
            FNC(serverInit);
            AFNC(setVariablePublic);
        };
        MODULE(Mutex) {
            FNC(clientInitMutex);
            AFNC(mutex);
            FNC(serverInitMutex);
        };
        MODULE(Namespaces) {
            AFNC(allVariables);
            AFNC(createNamespace);
            AFNC(deleteNamespace);
            AFNC(getLogicGroup);
            AFNC(getVariable);
            AFNC(setVar);
            AFNC(setVariable);
        };
        MODULE(PerFrame) {
            AFNC(addPerframeHandler);
            AFNC(execNextFrame);
            FNC(initPerFrameHandler);
            AFNC(removePerframeHandler);
            AFNC(wait);
            AFNC(waitUnil);
        };
        MODULE(RemoteExecution) {
            AFNC(execute);
            AFNC(handleIncomeData);
            AFNC(remoteExec);
            AFNC(serverInitRemoteExec);
        };
        MODULE(Statemachine) {
            AFNC(addStatemachineState);
            AFNC(copyStatemachine);
            AFNC(createStatemachine);
            AFNC(createStatemachineFromConfig);
            AFNC(getVariableStatemachine);
            FNC(initStatemachine);
            AFNC(setVariableStatemachine);
            AFNC(startStatemachine);
            AFNC(stepStatemachine);
        };
        MODULE(StatusEffects) {
            AFNC(addStatusEffectType);
            FNC(initStatusEffects);
            AFNC(setStatusEffect);
        };
    };
};
