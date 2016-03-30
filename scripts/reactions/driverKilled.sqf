if(SC_infiSTAR_log) then 
{ 
	_logDetail = format ["[OCCUPATION:Vehicle]:: Unit %2 (driver) killed at %1",time,_this select 0]; 
	['A3_EXILE_OCCUPATION',_logDetail] call FNC_A3_CUSTOMLOG;
};

_deadDriver	= _this select 0;

_deadDriver removeAllMPEventHandlers  "mpkilled";
_deadDriver removeAllMPEventHandlers  "mphit";

// Select a replacement driver
_vehicleDriven = _deadDriver getVariable "SC_drivenVehicle";
_vehGroup = group _deadDriver;
[_deadDriver] join grpNull;
_nearAI = (position _vehicleDriven) nearEntities [["O_recon_F"], 100];
_replacementDriver = _nearAI call BIS_fnc_selectRandom;

if(SC_infiSTAR_log) then 
{
	_logDetail = format ["[OCCUPATION:Vehicle]:: Replacement Driver found (%1) for vehicle %2",_replacementDriver,_vehicleDriven]; 
	['A3_EXILE_OCCUPATION',_logDetail] call FNC_A3_CUSTOMLOG;
};

// add event handlers for the new driver
_replacementDriver addMPEventHandler ["mpkilled", "_this call SC_fnc_driverKilled;"];
_replacementDriver setVariable ["SC_drivenVehicle", _vehicleDriven,true];
_vehicleDriven removeAllMPEventHandlers  "mphit";
_vehicleDriven addMPEventHandler ["mphit", "_this call SC_fnc_repairVehicle;"];	

_replacementDriver assignAsDriver _vehicleDriven;
_vehicleDamage = getDammage _vehicleDriven;

// If the vehicle is already damaged then fix it, otherwise get in as the driver
if(_vehicleDamage > 0) then
{
	[_vehicleDriven] call SC_fnc_repairVehicle;
}
else
{
	[_replacementDriver] orderGetIn true;
	//_replacementDriver moveInDriver _vehicleDriven;
};



