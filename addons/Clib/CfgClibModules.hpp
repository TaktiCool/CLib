#define FNC(F) class F
#define APIFNC(f) class f {api = 1;}
#define MODULE(F) class F

class CfgClibModules {
    /*
    class PRA3 {
        path = "\pr\PRA3\addons\PRA3_Server\"; // TODO add Simplifyed Macro for this
        MODULE(Module2) {
            dependency[] = {};
            FNC(fnc1) {
                api = 1;
                onlyServer = 1;
            };
            FNC(fnc2) {};

            MODULE(Module3) {

            };
        };
        MODULE(Module1) {

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
