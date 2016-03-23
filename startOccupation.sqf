diag_log format ["[OCCUPATION]:: Giving the server time to start before starting [OCCUPATION] (%1)",time];
uiSleep 30;
diag_log format ["[OCCUPATION]:: Initialised at %1",time];


if(SC_debug) then { SC_refreshTime = 60; }else{ SC_refreshTime = 300; };

// Add selected occupation scripts to Exile Threading System

if(SC_occupyStatic) then
{
	uiSleep 15; // delay the start
	fnc_occupationStaticMonitor 	= compile preprocessFileLineNumbers "\x\addons\a3_exile_occupation\occupationStatic.sqf";
	[SC_refreshTime, fnc_occupationStaticMonitor, [], true] call ExileServer_system_thread_addTask;
};

if(SC_occupySky) then
{
	uiSleep 15; // delay the start
	fnc_occupationSkyMonitor 	= compile preprocessFileLineNumbers "\x\addons\a3_exile_occupation\occupationSky.sqf";
	[SC_refreshTime, fnc_occupationSkyMonitor, [], true] call ExileServer_system_thread_addTask;
};

if(SC_occupyVehicle) then
{
	uiSleep 15; // delay the start
	fnc_occupationVehicleMonitor 	= compile preprocessFileLineNumbers "\x\addons\a3_exile_occupation\occupationVehicle.sqf";
	[SC_refreshTime, fnc_occupationVehicleMonitor, [], true] call ExileServer_system_thread_addTask;
};

if(SC_occupyPlaces) then
{
	uiSleep 15; // delay the start
	fnc_occupationMonitor 			= compile preprocessFileLineNumbers "\x\addons\a3_exile_occupation\occupation.sqf";
	[SC_refreshTime, fnc_occupationMonitor, [], true] call ExileServer_system_thread_addTask;
};



if(SC_occupyMilitary) then
{
	uiSleep 15; // delay the start
	fnc_occupationMilitaryMonitor 	= compile preprocessFileLineNumbers "\x\addons\a3_exile_occupation\occupationMilitary.sqf";
	[SC_refreshTime, fnc_occupationMilitaryMonitor, [], true] call ExileServer_system_thread_addTask;
};




diag_log format ["[OCCUPATION]:: threads added at %1",time];