#define DFNC(f) class f
#define FNC(f) DFNC(f)
#define APIFNC(f) DFNC(f) {api = 1;}
#define MODULE(m) class m

class CfgCLibModules {
    class CLib {
        path = "\pr\CLib\addons\CLib";

        MODULE(Core) {
            dependency[] = {"CLib/Events"};

            FNC(init);

            MODULE(Autoload) {
                FNC(autoloadEntryPoint);
                FNC(callModules);
                APIFNC(loadModules);
                FNC(loadModulesServer);
                FNC(sendFunctions);
                FNC(sendFunctionsLoop);
            };

            MODULE(Misc) {
                APIFNC(addPerformanceCounter);
                APIFNC(blurScreen);
                APIFNC(cachedCall);
                APIFNC(codeToString);
                APIFNC(createPPEffect);
                APIFNC(deleteAtEntry);
                APIFNC(directCall);
                APIFNC(disableUserInput);
                // APIFNC(dumpPerformanceInformation); // FIXME
                APIFNC(getPos);
                APIFNC(fileExist);
                APIFNC(flatConfigPath);
                APIFNC(findSavePosition);
                APIFNC(fixFloating);
                APIFNC(fixPosition);
                APIFNC(getFOV);
                APIFNC(getNearUnits);
                APIFNC(groupPlayers);
                APIFNC(initVoiceDetection);
                APIFNC(log);
                APIFNC(name);
                APIFNC(sanitizeString);
                FNC(serverInit);
                APIFNC(shuffleArray);
                FNC(dumpPerformanceInformation);
                APIFNC(setVariablePublic);
            };

            MODULE(MissionModuleLoader) {
                FNC(postInit);
            };
        };

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
            dependency[] = {"CLib/PerFrame", "CLib/Namespaces", "CLib/RemoteExecution"};
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
            FNC(client);
            FNC(server) { serverOnly = 1; };
            APIFNC(isLocalised);
            APIFNC(readLocalisation);
            APIFNC(formatLocalisation);
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
            APIFNC(loadLoadout);
            APIFNC(applyLoadout);
            FNC(init);
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
            dependency[] = {"CLib/Events"};
            APIFNC(addAction);
            APIFNC(addCanInteractWith);
            APIFNC(addHoldAction);
            APIFNC(canInteractWith);
            FNC(clientInitCanInteractWith);
            FNC(clientInitInteraction);
            APIFNC(holdActionCallback);
            APIFNC(inRange);
            FNC(onCursorObjectChanged);
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
            APIFNC(nearestMapGraphicsGroup);
            APIFNC(removeMapGraphicsEventhandler);
            APIFNC(removeMapGraphicsGroup);
            APIFNC(TriggerMapGraphicsEvent);
            APIFNC(registerMapControl);
            APIFNC(unregisterMapControl);
        };

        MODULE(Mutex) {
            dependency[] = {"CLib/Events"};
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
            FNC(execute);
            FNC(init);
            FNC(handleIncomeData);
            APIFNC(remoteExec);
            FNC(serverInit);
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
            dependency[] = {"CLib/Namespaces"};
            APIFNC(getSetting);
            FNC(init);
            APIFNC(loadSettings);
        };

        MODULE(SimpleObjectFramework) {
            dependency[] = {"CLib/Namespaces"};
            APIFNC(createSimpleObjectComp);
            FNC(init);
            APIFNC(readSimpleObjectComp);
            FNC(exportSimpleObjectComp) {
                api = 1;
                serverOnly = 1;
            };
        };
    };
};
