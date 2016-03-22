diag_log format ["[OCCUPATION]:: Giving the server time to start before starting [OCCUPATION] (%1)",time];
uiSleep 30;
diag_log format ["[OCCUPATION]:: Initialised at %1",time];


if(debug) then { refreshTime = 60; }else{ refreshTime = 300; };

// Add selected occupation scripts to Exile Threading System

if(occupySky) then
{
	uiSleep 30; // delay the start
	fnc_occupationSkyMonitor 	= compile preprocessFileLineNumbers "\x\addons\a3_exile_occupation\occupationSky.sqf";
	[refreshTime, fnc_occupationSkyMonitor, [], true] call ExileServer_system_thread_addTask;
};

if(occupyVehicle) then
{
	uiSleep 30; // delay the start
	fnc_occupationVehicleMonitor 	= compile preprocessFileLineNumbers "\x\addons\a3_exile_occupation\occupationVehicle.sqf";
	[refreshTime, fnc_occupationVehicleMonitor, [], true] call ExileServer_system_thread_addTask;
};

if(occupyStatic) then
{
	uiSleep 30; // delay the start
	fnc_occupationStaticMonitor 	= compile preprocessFileLineNumbers "\x\addons\a3_exile_occupation\occupationStatic.sqf";
	[refreshTime, fnc_occupationStaticMonitor, [], true] call ExileServer_system_thread_addTask;
};

if(occupyPlaces) then
{
	uiSleep 30; // delay the start
	fnc_occupationMonitor 			= compile preprocessFileLineNumbers "\x\addons\a3_exile_occupation\occupation.sqf";
	[refreshTime, fnc_occupationMonitor, [], true] call ExileServer_system_thread_addTask;
};

if(occupyMilitary) then
{
	uiSleep 30; // delay the start
	fnc_occupationMilitaryMonitor 	= compile preprocessFileLineNumbers "\x\addons\a3_exile_occupation\occupationMilitary.sqf";
	[refreshTime, fnc_occupationMilitaryMonitor, [], true] call ExileServer_system_thread_addTask;
};




diag_log format ["[OCCUPATION]:: threads added at %1",time];
