#define FNC(F) class F
#define APIFNC(f) class f {api = 1;}
#define MODULE(F) class F

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
        path = "\pr\Clib\addons\Clib\";

        MODULE(3dGraphics) {
            APIFNC();
        };
        MODULE(Autoload) {

        };
        MODULE(ConfigCaching) {

        };
        MODULE(Events) {

        };
        MODULE(Gear) {

        };
        MODULE(Interaction) {

        };
        MODULE(lnbData) {

        };
        MODULE(Localisation) {

        };
        MODULE(MapGraphics) {

        };
        MODULE(Misc) {

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
