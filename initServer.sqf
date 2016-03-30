////////////////////////////////////////////////////////////////////////////////////////////
//
//		Server Occupation script by second_coming
//
//		Version 2.1
//
//		http://www.exilemod.com/profile/60-second_coming/
//
//		This script uses the fantastic DMS by Defent and eraser1
//
//		http://www.exilemod.com/topic/61-dms-defents-mission-system/
//		special thanks to eichi for pointers on this script :)
//
////////////////////////////////////////////////////////////////////////////////////////////
//
//		I do not give permission for anyone to sell (or charge for the installation of)
//		any part of this set of scripts.
//
//		second_coming 2016
//
////////////////////////////////////////////////////////////////////////////////////////////

diag_log format ["[OCCUPATION MOD]:: Initialised at %1",time];

// EventHandlers for AI reactions
SC_fnc_repairVehicle 		= compile preprocessFileLineNumbers "\x\addons\a3_exile_occupation\scripts\reactions\repairVehicle.sqf";
SC_fnc_reactUnit 			= compile preprocessFileLineNumbers "\x\addons\a3_exile_occupation\scripts\reactions\reactUnit.sqf";
SC_fnc_driverKilled 		= compile preprocessFileLineNumbers "\x\addons\a3_exile_occupation\scripts\reactions\driverKilled.sqf";
SC_fnc_airHit 			= compile preprocessFileLineNumbers "\x\addons\a3_exile_occupation\scripts\reactions\airHit.sqf";

// Get the config for Occupation
call compile preprocessFileLineNumbers "\x\addons\a3_exile_occupation\config.sqf";

// Start Occupation
[] execVM "\x\addons\a3_exile_occupation\scripts\startOccupation.sqf";