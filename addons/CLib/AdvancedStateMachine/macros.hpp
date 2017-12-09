#define MODULE AdvancedStateMachine
#include "\tc\CLib\addons\CLib\CLib_Macros.hpp"

#define STATE(var) QGVAR(state) + var
#define TRANSITIONS(var) QGVAR(transitions) + var
