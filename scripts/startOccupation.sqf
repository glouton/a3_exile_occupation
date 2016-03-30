diag_log format ["[OCCUPATION]:: Giving the server time to start before starting [OCCUPATION] (%1)",time];
uiSleep 30;
diag_log format ["[OCCUPATION]:: Initialised at %1",time];


if(SC_debug) then { SC_refreshTime = 60; }else{ SC_refreshTime = 300; };

// Add selected occupation scripts to Exile Threading System

if(SC_occupyLootCrates) then
{
	if(SC_occupyLootCratesMarkers) then
	{
		fnc_occupationDeleteMapMarker 	= compile preprocessFileLineNumbers "\x\addons\a3_exile_occupation\scripts\deleteMapMarkers.sqf";
		[10, fnc_occupationDeleteMapMarker, [], true] call ExileServer_system_thread_addTask;	
	};
	call compile preprocessFileLineNumbers "\x\addons\a3_exile_occupation\scripts\occupationLootCrates.sqf";
};

if(SC_occupyHeliCrashes) then
{
	call compile preprocessFileLineNumbers "\x\addons\a3_exile_occupation\scripts\occupationHeliCrashes.sqf";
};

if(SC_occupyStatic) then
{
	uiSleep 15; // delay the start
	fnc_occupationStaticMonitor 	= compile preprocessFileLineNumbers "\x\addons\a3_exile_occupation\scripts\occupationStatic.sqf";
	[SC_refreshTime, fnc_occupationStaticMonitor, [], true] call ExileServer_system_thread_addTask;
};

if(SC_occupySky) then
{
	uiSleep 15; // delay the start
	fnc_occupationSkyMonitor 	= compile preprocessFileLineNumbers "\x\addons\a3_exile_occupation\scripts\occupationSky.sqf";
	[SC_refreshTime, fnc_occupationSkyMonitor, [], true] call ExileServer_system_thread_addTask;
};

if(SC_occupyVehicle) then
{
	uiSleep 15; // delay the start
	fnc_occupationVehicleMonitor 	= compile preprocessFileLineNumbers "\x\addons\a3_exile_occupation\scripts\occupationVehicle.sqf";
	[SC_refreshTime, fnc_occupationVehicleMonitor, [], true] call ExileServer_system_thread_addTask;
};

if(SC_occupyPlaces) then
{
	uiSleep 15; // delay the start
	fnc_occupationMonitor 			= compile preprocessFileLineNumbers "\x\addons\a3_exile_occupation\scripts\occupation.sqf";
	[SC_refreshTime, fnc_occupationMonitor, [], true] call ExileServer_system_thread_addTask;
};



if(SC_occupyMilitary) then
{
	uiSleep 15; // delay the start
	fnc_occupationMilitaryMonitor 	= compile preprocessFileLineNumbers "\x\addons\a3_exile_occupation\scripts\occupationMilitary.sqf";
	[SC_refreshTime, fnc_occupationMilitaryMonitor, [], true] call ExileServer_system_thread_addTask;
};




diag_log format ["[OCCUPATION]:: threads added at %1",time];