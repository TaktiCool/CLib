#include "\tc\CLib\addons\CLib\Statemachine\macros.hpp"

#define STATE(var) QGVAR(state) + var
#define TRANSITIONS(var) QGVAR(transitions) + var
#define EVENTTRANSITIONS(var) QGVAR(eventransitions) + var
