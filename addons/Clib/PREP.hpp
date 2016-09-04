// Per Frame Eventhandler
EPREP(PerFrame,addPerFrameHandler)
EPREP(PerFrame,removePerFrameHandler)
EPREP(PerFrame,initPerFrameHandler)
EPREP(PerFrame,execNextFrame)
EPREP(PerFrame,wait)
EPREP(PerFrame,waitUntil)

// Events
EPREP(Events,initEvents)
EPREP(Events,addEventHandler)
EPREP(Events,removeEventhandler)

// Trigger Events
EPREP(Events,localEvent)
EPREP(Events,targetEvent)
EPREP(Events,globalEvent)
EPREP(Events,serverEvent)

// Base Eventhandler
EPREP(Events,clientInitEvents)
EPREP(Events,serverInitEvents)
EPREP(Events,hcInitEvents)
EPREP(Events,fn_addIgnoredEventLog)

// Localization
EPREP(Localisation,initLocalisation)
EPREP(Localisation,readLocalisation)
EPREP(Localisation,isLocalised)

// Autoload
EPREP(Autoload,autoloadEntryPoint)
EPREP(Autoload,callModules)
EPREP(Autoload,loadModules)
EPREP(Autoload,sendFunctions)
EPREP(Autoload,sendFunctionsLoop)
EPREP(Autoload,loadModulesServer)

// Config Caching
EPREP(ConfigCaching,returnParents)
EPREP(ConfigCaching,configProperties)
EPREP(ConfigCaching,initConfigCaching)

//Entity Variables
EPREP(EntityVariables,initEntityVariables)

// Gear
EPREP(Gear,addContainer)
EPREP(Gear,copyGear)
EPREP(Gear,saveGear)
EPREP(Gear,restoreGear)
EPREP(Gear,addItem)
EPREP(Gear,addMagazine)
EPREP(Gear,addWeapon)
EPREP(Gear,getAllGear)

// Interaction
EPREP(Interaction,addAction)
EPREP(Interaction,addHoldAction)
EPREP(Interaction,holdActionCallback)
EPREP(Interaction,overrideAction)
EPREP(Interaction,clientInitInteraction)
EPREP(Interaction,loop)
EPREP(Interaction,inRange)

// canInteractWith
EPREP(Interaction,addCanInteractWith)
EPREP(Interaction,canInteractWith)
EPREP(Interaction,clientInitCanInteractWith)

// lnbData
EPREP(lnbData,initlnbData)
EPREP(lnbData,lnbLoad)
EPREP(lnbData,lnbSave)

// MapGraphics
EPREP(MapGraphics,addMapGraphicsEventHandler)
EPREP(MapGraphics,addMapGraphicsGroup)
EPREP(MapGraphics,buildMapGraphicsCache)
EPREP(MapGraphics,clientInitMapGraphics)
EPREP(MapGraphics,drawMapGraphics)
EPREP(MapGraphics,mapGraphicsMouseButtonClick)
EPREP(MapGraphics,mapGraphicsMouseMoving)
EPREP(MapGraphics,mapGraphicsPosition)
EPREP(MapGraphics,nearestMapGraphicsGroup)
EPREP(MapGraphics,registerMapControl)
EPREP(MapGraphics,removeMapGraphicsEventHandler)
EPREP(MapGraphics,removeMapGraphicsGroup)
EPREP(MapGraphics,unregisterMapControl)
EPREP(MapGraphics,triggerMapGraphicsEvent)

// 3dGraphics
EPREP(3dGraphics,clientInit3dGraphics)
EPREP(3dGraphics,add3dGraphics)
EPREP(3dGraphics,remove3dGraphics)
EPREP(3dGraphics,build3dGraphicsCache)
EPREP(3dGraphics,draw3dGraphics)
EPREP(3dGraphics,3dGraphicsPosition)

// Mutex
EPREP(Mutex,initClientMutex)
EPREP(Mutex,initServerMutex)
EPREP(Mutex,mutex)

// Namespaces
EPREP(Namespaces,createNamespace)
EPREP(Namespaces,deleteNamespace)

EPREP(Namespaces,setVariable)
EPREP(Namespaces,getVariable)
EPREP(Namespaces,allVariables)

EPREP(Namespaces,setVar)

EPREP(Namespaces,getLogicGroup)

// Notification System
EPREP(Notification,clientInitNotification)
EPREP(Notification,displayNotification)
EPREP(Notification,handleNotificationQueue)

// Respawn
EPREP(Respawn,respawn)
EPREP(Respawn,respawnNewSide)

// Settings
EPREP(Settings,initSettings)
EPREP(Settings,loadSettings)
EPREP(Settings,getSetting)

// StatusEffects
EPREP(StatusEffects,initStatusEffects)
EPREP(StatusEffects,addStatusEffectType)
EPREP(StatusEffects,setStatusEffect)

// Statemaschine
EPREP(Statemachine,startStatemachine)
EPREP(Statemachine,stepStatemachine)
EPREP(Statemachine,createStatemachine)
EPREP(Statemachine,createStatemachineFromConfig)
EPREP(Statemachine,copyStatemachine)
EPREP(Statemachine,addStatemachineState)
EPREP(Statemachine,setVariableStatemachine)
EPREP(Statemachine,getVariableStatemachine)

// Performance Info
EPREP(PerformanceInfo,clientInitPerformance)
EPREP(PerformanceInfo,serverInitPerformance)
EPREP(PerformanceInfo,dumpPerformanceInformation)

// Init
PREP(init)

// Other Functions
PREP(addPerformanceCounter)
PREP(blurScreen)
PREP(cachedCall)
PREP(codeToString)
PREP(createPPEffect)
PREP(directCall)
PREP(deleteAtEntry)
PREP(disableUserInput)
PREP(findSavePosition)
PREP(fixFloating)
PREP(fixPosition)
PREP(getFOV)
PREP(getNearestLocationName)
PREP(getNearUnits)
PREP(groupPlayers)
PREP(isAlive)
PREP(name)
PREP(sanitizeString)
PREP(setVariablePublic)

PREP(serverInit)
