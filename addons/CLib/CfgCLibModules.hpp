#define DFNC(f) class f
#define FNC(f) DFNC(f)
#define APIFNC(f) DFNC(f) {api = 1;}
#define MODULE(m) class m

class CfgCLibModules {
    class CLib {
        path = "\pr\CLib\addons\CLib";

        MODULE(PerFrame) {
            dependency[] = {"CLib/Namespaces"};
            APIFNC(addPerframeHandler);
            APIFNC(execNextFrame);
            FNC(init);
            APIFNC(removePerframeHandler);
            APIFNC(wait);
            APIFNC(waitUntil);
        };

        MODULE(Events) {
            dependency[] = {"CLib/PerFrame", "CLib/Namespaces", "CLib/RemoteExecution"/*, "CLib/TestFail"*/};
            APIFNC(addEventHandler);
            APIFNC(addIgnoredEventLog);
            FNC(clientInit);
            APIFNC(globalEvent);
            FNC(hcInit);
            FNC(init);
            APIFNC(localEvent);
            APIFNC(removeEventhandler);
            APIFNC(serverEvent);
            FNC(serverInit);
            APIFNC(targetEvent);
        };

        MODULE(Localisation) {
            dependency[] = {"CLib/Events"};
            FNC(init);
            APIFNC(isLocalised);
            APIFNC(readLocalisation);
        };

        MODULE(Autoload) {
            dependency[] = {"CLib/PerFrame"};
            APIFNC(autoloadEntryPoint);
            APIFNC(callModules);
            APIFNC(loadModules);
            APIFNC(sendFunctions);
            APIFNC(sendFunctionsLoop);
        };

        MODULE(ConfigCaching) {
            dependency[] = {"CLib/Namespaces"};
            APIFNC(configProperties);
            FNC(init);
            APIFNC(returnParents);
        };

        MODULE(3dGraphics) {
            dependency[] = {"CLib/Events"};
            APIFNC(3dGraphicsPosition);
            APIFNC(add3dGraphics);
            APIFNC(build3dGraphicsCache);
            FNC(clientInit);
            APIFNC(draw3dGraphics);
            APIFNC(remove3dGraphics);
        };

        MODULE(extensionFramework) {
            dependency[] = {};
            APIFNC(callExtension);
            FNC(init);
            APIFNC(remoteCallExtension);
            APIFNC(splitOutputString);
        };

        MODULE(Gear) {
            dependency[] = {};
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
            dependency[] = {"CLib/Namespaces", "CLib/PerFrame"};
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
            dependency[] = {"CLib/Namespaces", "CLib/PerFrame"};
            FNC(init);
            APIFNC(lnbLoad);
            APIFNC(lnbSave);
        };

        MODULE(MapGraphics) {
            dependency[] = {"CLib/Events"};
            APIFNC(addMapGraphicsEventHandler);
            APIFNC(addMapGraphicsGroup);
            APIFNC(buildMapGraphicsCache);
            FNC(clientInit);
            APIFNC(drawMapGraphics);
            APIFNC(mapGraphicsMouseButtonClick);
            APIFNC(mapGraphicsMouseMoving);
            APIFNC(mapGraphicsPosition);
            APIFNC(removeMapGraphicsEventhandler);
            APIFNC(removeMapGraphicsGroup);
            APIFNC(TriggerMapGraphicsEvent);
            APIFNC(registerMapControl);
            APIFNC(unregisterMapControl);
        };

        MODULE(Misc) {
            dependency[] = {"CLib/Namespaces", "CLib/PerFrame", "CLib/Events"};
            APIFNC(addPerformanceCounter);
            APIFNC(blurScreen);
            APIFNC(cachedCall);
            APIFNC(codeToString);
            APIFNC(createPPEffect);
            APIFNC(deleteAtEntry);
            APIFNC(directCall);
            APIFNC(disableUserInput);
            APIFNC(findSavePosition);
            APIFNC(fixFloating);
            APIFNC(fixPosition);
            APIFNC(getFOV);
            APIFNC(getNearUnits);
            APIFNC(groupPlayers);
            FNC(init);
            APIFNC(name);
            APIFNC(sanitizeString);
            FNC(serverInit);
            FNC(dumpPerformanceInformation);
            APIFNC(setVariablePublic);
        };

        MODULE(Mutex) {
            dependency[] = {"CLib/Namespaces", "CLib/PerFrame", "CLib/Events"};
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
            dependency[] = {};
            APIFNC(execute);
            APIFNC(handleIncomeData);
            APIFNC(remoteExec);
            APIFNC(serverInit);
        };

        MODULE(Statemachine) {
            dependency[] = {"CLib/Events"};
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
            dependency[] = {"CLib/Events"};
            APIFNC(addStatusEffectType);
            FNC(init);
            APIFNC(setStatusEffect);
        };

        MODULE(AnimFramework) {
            dependency[] = {"CLib/Events"};
            APIFNC(doAnimation);
            APIFNC(getDeathAnimation);
            APIFNC(getDefaultAnimation);
            FNC(init);
        };
        MODULE(Settings) {
            APIFNC(getSetting);
            FNC(init);
            APIFNC(loadSettings);
        };

        MODULE(SimpleObjectFramework) {
            dependency[] = {"CLib/Namespaces"};
            APIFNC(createSimpleObjectComp);
            FNC(init);
            APIFNC(readSimpleObjectComp);
        };
    };
};
