#define FNC(F) class F
#define MODULE(F) class F

class CfgClibModules {
  class PRA3 {
    path = "pr";
  	MODULE(Module2) {
        FNC(fnc2) {
          api = 1;
          onlyServer = 1;
        };
        FNC(fnc2){};

        class Module3 {

        };
    };
    class Module1 {

    };
  };
  class Clib {
	path = "pr";
  };

};
