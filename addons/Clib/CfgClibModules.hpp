#define FNC(f) class f : ClibBaseFunction {}
#define DFNC(f) class f : ClibBaseFunction
#define APIFNC(f) class f : ClibBaseFunction {api = 1;}
#define MODULE(m) class m : ClibBaseModule

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

        MODULE(N3dGraphics) {
            FNC(N3dGraphicsPosition);
            FNC(add3dGraphics);
            FNC(build3dGraphicsCache);
            FNC(clientInit3dGraphics);
            FNC(draw3dGraphics);
            FNC(remove3dGraphics);
        };
        MODULE(Autoload) {
            FNC(autoloadEntryPoint);
            FNC(callModules);
            FNC(loadModules);
            FNC(sendFunctions);
            FNC(sendFunctionsLoop);
        };
        MODULE(ConfigCaching) {
            FNC(configProperties);
            FNC(initConfigCaching);
            FNC(returnParents);
        };
        MODULE(Events) {
            FNC(addEventHandler);
            FNC(addIgnoredEventLog);
            FNC(clientInitEvents);
            FNC(globalEvent);
            FNC(hcInitEvents);
            FNC(initEvents);
            FNC(localEvent);
            FNC(removeEventhandler);
            FNC(serverEvent);
            FNC(servetInitEvents);
            FNC(targetEvent);
        };
        MODULE(extensionFramework) {
            FNC(callExtension);
            FNC(init);
            FNC(remoteCallExtension);
            FNC(splitOutputString);
        };
        MODULE(Gear) {
            FNC(addContainer);
            FNC(addItem);
            FNC(addMagazine);
            FNC(addWeapon);
            FNC(copyGear);
            FNC(getAllGear);
            FNC(restoreGear);
            FNC(saveGear);
        };
        MODULE(Interaction) {
            FNC(addAction);
            FNC(addCanInteractWith);
            FNC(addHoldAction);
            FNC(canInteractWith);
            FNC(clientInitCanInteractWith);
            FNC(clientInitInteraction);
            FNC(holdActionCallback);
            FNC(inRange);
            FNC(loop);
            FNC(overrideAction);
        };
        MODULE(lnbData) {
            FNC(initlnbData);
            FNC(lnbLoad);
            FNC(lnb);
        };
        MODULE(Localisation) {
            FNC(initLocalisation);
            FNC(isLocalised);
            FNC(readLocalisation);
        };
        MODULE(MapGraphics) {
            FNC(addMapGraphicsEventHandler);
            FNC(addMapGraphicsGroup);
            FNC(buildMapGraphicsCache);
            FNC(clientInitMapGraphics);
            FNC(drawMapGraphics);
            FNC(mapGraphicsMouseButtionClick);
            FNC(mapGraphicsMouseMoving);
            FNC(mapGraphicsPosition);
            FNC(removeMapGraphicsEventhandler);
            FNC(removeMapGraphicsGroup);
            FNC(TriggerMapGraphicsEvent);
            FNC(registerMapControl);
            FNC(unregisterMapControl);
        };
        MODULE(Misc) {
            //FNC();
        };
        MODULE(Mutex) {

        };
        MODULE(Namespaces) {

        };
        MODULE(Notification) {

        };
        MODULE(PerFrame) {

        };
        MODULE(RemoteExecution) {

        };
        MODULE(Statemachine) {

        };
        MODULE(StatusEffects) {

        };
    };
};
