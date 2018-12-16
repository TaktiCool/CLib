#include "ModuleMacros.hpp"

class CfgCLibModules {
    class CLib {
        path = "\tc\CLib\addons\CLib";

        MODULE(3dGraphics) {
            dependency[] = {"CLib/Events"};
            FNC(3dGraphicsPosition);
            APIFNC(add3dGraphics);
            FNC(build3dGraphicsCache);
            FNC(clientInit);
            FNC(draw3dGraphics);
            APIFNC(remove3dGraphics);
        };

        MODULE(AdvancedStateMachine) {
            dependency[] = {"CLib/Events", "CLib/Namespaces", "CLib/PerFrame"};
            APIFNC(addASMState);
            APIFNC(addASMTransition);
            APIFNC(createASM);
            APIFNC(createASMInstance);
            FNC(stepASM);
        };

        MODULE(AnimFramework) {
            dependency[] = {"CLib/Events"};
            APIFNC(doAnimation);
            APIFNC(getDeathAnimation);
            APIFNC(getDefaultAnimation);
            FNC(init);
        };

        MODULE(ConfigCaching) {
            dependency[] = {"CLib/Namespaces"};
            FNC(arrayToPath);
            APIFNC(configProperties);
            APIFNC(getConfigDataCached);
            APIFNC(getConfigData);
            FNC(init);
            APIFNC(returnParents);
        };

        MODULE(Core) {
            dependency[] = {"CLib/Events"};

            FNC(init);

            MODULE(Autoload) {
                FNCSERVER(autoloadEntryPoint);
                FNC(callModules);
                APIFNCSERVER(loadModules);
                FNCSERVER(loadModulesServer);
                FNCSERVER(sendFunctions);
                FNCSERVER(sendFunctionsLoop);
            };

            MODULE(Compression) {
                FNCSERVER(checkAllFunctionCompression);
                FNCSERVER(checkCompression);
                FNCSERVER(compressString);
                APIFNCSERVER(decompressString);
            };

            MODULE(ExtensionFramework) {
                APIFNC(callExtension);
                APIFNCSERVER(extensionRequest);
                FNCSERVER(extensionFetch);
                FNC(initExtensionFramework);
                FNC(serverInitExtensionFramework);
            };

            MODULE(Misc) {
                APIFNC(blurScreen);
                APIFNC(cachedCall);
                APIFNC(codeToString);
                APIFNC(compatibleMagazines);
                APIFNC(createPPEffect);
                APIFNC(deleteAtEntry);
                APIFNC(directCall);
                APIFNC(disableUserInput);
                APIFNC(getPos);
                APIFNC(fileExist);
                APIFNC(flatConfigPath);
                APIFNC(findSavePosition);
                APIFNC(fixFloating);
                APIFNC(fixPosition);
                APIFNC(getFOV);
                APIFNC(getNearUnits);
                APIFNC(groupPlayers);
                APIFNC(inFOV);
                FNC(initVoiceDetection);
                APIFNC(isKindOfArray);
                APIFNC(log);
                APIFNC(messageBox);
                APIFNC(modLoaded);
                APIFNC(moduleLoaded);
                APIFNC(name);
                APIFNC(registerEntryPoint);
                APIFNC(sanitizeString);
                APIFNC(shuffleArray);
                APIFNC(setVariablePublic);
                APIFNC(textTiles);
                APIFNC(toFixedNumber);
            };

            MODULE(MissionModuleLoader) {
                FNC(postInit);
            };
        };

        MODULE(Events) {
            dependency[] = {"CLib/PerFrame", "CLib/Namespaces", "CLib/RemoteExecution"};
            APIFNC(addEventHandler);
            APIFNC(addIgnoredEventLog);
            FNC(clientInit);
            APIFNC(globalEvent);
            FNC(hcInit);
            FNC(init);
            APIFNC(invokePlayerChanged);
            APIFNC(localEvent);
            APIFNC(removeEventhandler);
            APIFNC(serverEvent);
            FNC(serverInit);
            APIFNC(targetEvent);
        };

        MODULE(GarbageCollector) {
            dependency[] = {"CLib/Statemachine", "CLib/Events"};
            FNC(serverInit);
        };

        MODULE(Gear) {
            dependency[] = {"CLib/PerFrame"};
            MODULE(Loadout) {
                APIFNC(getAllLoadouts);
                APIFNC(getLoadoutDetails);
                APIFNC(loadLoadout);
                APIFNC(applyLoadout);
                FNC(init);
            };
            APIFNC(addContainer);
            APIFNC(addItem);
            APIFNC(addMagazine);
            APIFNC(addWeapon);
            APIFNC(copyGear);
            APIFNC(getAllGear);
            APIFNC(restoreGear);
            APIFNC(saveGear);
        };

        MODULE(Hashes) {
            APIFNC(containsKey);
            APIFNC(containsValue);
            APIFNC(countHash);
            APIFNC(createHash);
            APIFNC(forEachHash);
            APIFNC(getHash);
            APIFNC(hashToNamespace);
            APIFNC(namespaceToHash);
            APIFNC(setHash);
        };

        MODULE(Interaction) {
            dependency[] = {"CLib/Events"};
            APIFNC(addAction);
            APIFNC(addCanInteractWith);
            APIFNC(addHoldAction);
            APIFNC(canInteractWith);
            FNC(clientInitCanInteractWith);
            FNC(clientInitInteraction);
            FNC(holdActionCallback);
            APIFNC(inRange);
            FNC(onCursorObjectChanged);
            APIFNC(overrideAction);
        };

        MODULE(lnbData) {
            dependency[] = {"CLib/Namespaces", "CLib/PerFrame"};
            APIFNC(lnbLoad);
            APIFNC(lnbSave);
        };

        MODULE(Localisation) {
            dependency[] = {"CLib/Events"};
            FNC(init);
            FNC(client);
            FNCSERVER(server);
            APIFNC(isLocalised);
            APIFNC(readLocalisation);
            APIFNC(formatLocalisation);
        };

        MODULE(MapGraphics) {
            dependency[] = {"CLib/Events"};
            APIFNC(addMapGraphicsEventHandler);
            APIFNC(addMapGraphicsGroup);
            APIFNC(buildMapGraphicsCache);
            FNC(clientInit);
            APIFNC(drawMapGraphics);
            APIFNC(mapGraphicsMouseButtonClick);
            APIFNC(mapGraphicsMouseButtonDblClick);
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
            APIFNC(setVariable);
        };

        MODULE(ObjectPooling) {
            APIFNC(getPooledObject);
            APIFNC(getPooledObjectCondition);
            APIFNC(getPooledUnit);
            FNCSERVER(init);
        };

        MODULE(PerformanceInfo) {
            dependency[] = {"CLib/Events"};
            FNC(clientInit);
            APIFNC(dumpPerformanceInfo);
        };

        MODULE(PerFrame) {
            dependency[] = {"CLib/Namespaces"};
            APIFNC(addPerframeHandler);
            APIFNC(execNextFrame);
            FNC(init);
            APIFNC(removePerframeHandler);
            APIFNC(skipFrames);
            APIFNC(wait);
            APIFNC(waitUntil);
        };

        MODULE(RemoteExecution) {
            FNC(execute);
            FNC(init);
            FNCSERVER(handleIncomeData);
            APIFNC(remoteExec);
            FNC(serverInit);
        };

        MODULE(Settings) {
            dependency[] = {"CLib/Namespaces"};
            FNC(init);
            APIFNC(getSetting);
            APIFNC(getSettings);
            APIFNC(getSettingSubClasses);
            APIFNC(registerSettings);
        };

        MODULE(SimpleObjectFramework) {
            dependency[] = {"CLib/Namespaces", "CLib/Events"};
            APIFNC(createSimpleObjectComp);
            APIFNC(deleteSimpleObjectComp);
            FNC(init);
            APIFNC(readSimpleObjectComp);
            APIFNCSERVER(exportSimpleObjectComp);
        };

        MODULE(StateMachine) {
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
    };
};
