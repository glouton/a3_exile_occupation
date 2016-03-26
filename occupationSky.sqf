////////////////////////////////////////////////////////////////////////
//
//		Server Occupation script by second_coming
//
//		Version 2.0
//
//		http://www.exilemod.com/profile/60-second_coming/
//
//		This script uses the fantastic DMS by Defent and eraser1
//
//		http://www.exilemod.com/topic/61-dms-defents-mission-system/
//
////////////////////////////////////////////////////////////////////////

diag_log format['[OCCUPATION:Sky] Started'];

if (!isServer) exitWith {};

if(SC_liveHelis >= SC_maxNumberofHelis) exitWith {};

_vehiclesToSpawn = (SC_maxNumberofHelis - SC_liveHelis);
_middle = worldSize/2;
_spawnCenter = [_middle,_middle,0];
_maxDistance = _middle;

_locations = (nearestLocations [_spawnCenter, ["NameVillage","NameCity", "NameCityCapital"], _maxDistance]);
_i = 0;
{
	_okToUse = true;
	_pos = position _x;	
	_nearestMarker = [allMapMarkers, _pos] call BIS_fnc_nearestPosition; // Nearest Marker to the Location		
	_posNearestMarker = getMarkerPos _nearestMarker;
	if(_pos distance _posNearestMarker < 2500) exitwith { _okToUse = false; };

	if(!_okToUse) then
	{
		_locations deleteAt _i;
	};
	_i = _i + 1;
	sleep 0.2;

} forEach _locations;

for "_i" from 1 to _vehiclesToSpawn do
{
   private["_group"];
   _Location = _locations call BIS_fnc_selectRandom;
   
   _position = position _Location;	
   _spawnLocation = [_position select 0, _position select 1, 300];

	_group = createGroup east;
	_HeliClassToUse = SC_HeliClassToUse call BIS_fnc_selectRandom;
	_vehicle1 = [ [_spawnLocation], _group, "assault", "difficult", "bandit", _HeliClassToUse ] call DMS_fnc_SpawnAIVehicle;
	
	if(SC_infiSTAR_log) then 
	{ 
		_logDetail = format['[OCCUPATION:Sky] %1 spawned @ %2',_HeliClassToUse,_spawnLocation];	
		['A3_EXILE_OCCUPATION',_logDetail] call FNC_A3_CUSTOMLOG;
	};
	_vehicle1 setVehiclePosition [_spawnLocation, [], 0, "FLY"];
	_vehicle1 setVariable ["vehicleID", _spawnLocation, true];  
	_vehicle1 setFuel 1;
	_vehicle1 setDamage 0;
	_vehicle1 engineOn true;
	_vehicle1 flyInHeight 150;
	sleep 0.2;
	
	[_group, _spawnLocation, 2000] call bis_fnc_taskPatrol;
	_group setBehaviour "AWARE";
	_group setCombatMode "RED";
	SC_liveHelis = SC_liveHelis + 1;
	_vehicle1 addMPEventHandler ["mpkilled", "SC_liveHelis = SC_liveHelis - 1;"];
	_vehicle1 addMPEventHandler ["mphit", "_this call SC_fnc_airHit;"];
	_vehicle1 setVariable ["SC_crewEjected", false,true];	
	sleep 0.2;
	
};


diag_log format['[OCCUPATION:Sky] Running'];