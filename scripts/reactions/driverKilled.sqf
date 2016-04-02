// Triggered when the designated driver for a vehicle is killed
// Attempts to select a new driver from the same group

if(SC_extendedLogging) then 
{ 
	_logDetail = format ["[OCCUPATION:Vehicle]:: Unit %2 (driver) killed at %1",time,_this select 0]; 
	[_logDetail] call SC_fnc_log;
};

_deadDriver	= _this select 0;
_deadDriver removeAllMPEventHandlers  "mpkilled";
_vehicleDriven = _deadDriver getVariable "SC_drivenVehicle";


if(SC_debug) then
{
    { detach _x; deleteVehicle _x; } forEach attachedObjects _deadDriver;
};

// Select a replacement driver
_vehicleDriven removeAllMPEventHandlers  "mphit";
_vehGroup = group _vehicleDriven;
[_deadDriver] join grpNull;
if(count units _vehGroup > 0) then
{
    _logDetail = format ["[OCCUPATION:Vehicle]:: vehicle: %1 group: %2 units left:%3",_vehicleDriven,_vehGroup,count units _vehGroup]; 
    [_logDetail] call SC_fnc_log;       
    _groupMembers = units _vehGroup;
    _replacementDriver = _groupMembers call BIS_fnc_selectRandom;
    
    if(!alive _replacementDriver) exitWith { [_replacementDriver] call SC_fnc_driverKilled; }; 
 
    if (isNil "_replacementDriver") exitWith 
    {
        _logDetail = format ["[OCCUPATION:Vehicle]:: No replacement Driver found for vehicle %1",_vehicleDriven]; 
        [_logDetail] call SC_fnc_log;        
    };
    
    if(SC_debug) then
    {
        _tag = createVehicle ["Sign_Arrow_Green_F", position _replacementDriver, [], 0, "CAN_COLLIDE"];
        _tag attachTo [_replacementDriver,[0,0,0.6],"Head"];  
    };
        
    _replacementDriver disableAI "TARGET";
    _replacementDriver disableAI "AUTOTARGET";
    _replacementDriver disableAI "AUTOCOMBAT";
    _replacementDriver disableAI "COVER"; 
    
    _replacementDriver assignAsDriver _vehicleDriven;
        
    _vehicleDriven addMPEventHandler ["mphit", "_this call SC_fnc_repairVehicle;"];
    _replacementDriver addMPEventHandler ["mpkilled", "_this call SC_fnc_driverKilled;"];
    _replacementDriver setVariable ["DMS_AssignedVeh",_vehicleDriven];  
    _replacementDriver setVariable ["SC_drivenVehicle", _vehicleDriven,true];	 
    _vehicleDriven setVariable ["SC_assignedDriver", _replacementDriver,true];
    _replacementDriver doMove (position _vehicleDriven);   	
    _replacementDriver action ["movetodriver", _vehicleDriven];
    

    if(SC_extendedLogging) then 
    {
        _logDetail = format ["[OCCUPATION:Vehicle]:: Replacement Driver found (%1) for vehicle %2",_replacementDriver,_vehicleDriven]; 
        [_logDetail] call SC_fnc_log;
    };

    if(damage _vehicleDriven > 0) then 
    {
        [_replacementDriver] call SC_fnc_repairVehicle;
        
    };  
};
