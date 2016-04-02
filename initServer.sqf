////////////////////////////////////////////////////////////////////////////////////////////
//
//		Server Occupation script by second_coming
//
//		Version 3
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

SC_occupationVersion = "3.0";

diag_log format ["[OCCUPATION MOD]:: Occupation v%2 Initialised at %1",time,SC_occupationVersion];

// EventHandlers for AI reactions
SC_fnc_repairVehicle 		= compile preprocessFileLineNumbers "\x\addons\a3_exile_occupation\scripts\reactions\repairVehicle.sqf";
SC_fnc_reactUnit 			= compile preprocessFileLineNumbers "\x\addons\a3_exile_occupation\scripts\reactions\reactUnit.sqf";
SC_fnc_driverKilled 		= compile preprocessFileLineNumbers "\x\addons\a3_exile_occupation\scripts\reactions\driverKilled.sqf";
SC_fnc_airHit 			    = compile preprocessFileLineNumbers "\x\addons\a3_exile_occupation\scripts\reactions\airHit.sqf";
SC_fnc_getIn			    = compile preprocessFileLineNumbers "\x\addons\a3_exile_occupation\scripts\reactions\getIn.sqf";

// Get the config for Occupation
call compile preprocessFileLineNumbers "\x\addons\a3_exile_occupation\config.sqf";

// Select the log style depending on config settings
SC_fnc_log			        = compile preprocessFileLineNumbers "\x\addons\a3_exile_occupation\scripts\occupationLog.sqf";

// Start Occupation
[] execVM "\x\addons\a3_exile_occupation\scripts\startOccupation.sqf";