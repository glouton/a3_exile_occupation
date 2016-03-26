diag_log format ["[OCCUPATION MOD]:: Initialised at %1",time];

SC_fnc_repairVehicle 		= compile preprocessFileLineNumbers "\x\addons\a3_exile_occupation\reactions\repairVehicle.sqf";
SC_fnc_reactUnit 			= compile preprocessFileLineNumbers "\x\addons\a3_exile_occupation\reactions\reactUnit.sqf";
SC_fnc_driverKilled 		= compile preprocessFileLineNumbers "\x\addons\a3_exile_occupation\reactions\driverKilled.sqf";
SC_fnc_airHit 			= compile preprocessFileLineNumbers "\x\addons\a3_exile_occupation\reactions\airHit.sqf";

call compile preprocessFileLineNumbers "\x\addons\a3_exile_occupation\config.sqf";
[] execVM "\x\addons\a3_exile_occupation\startOccupation.sqf";

if(SC_occupyLootCrates) then
{
	call compile preprocessFileLineNumbers "\x\addons\a3_exile_occupation\occupationLootCrates.sqf";
};

