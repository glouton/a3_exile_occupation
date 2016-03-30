if (!isServer) exitWith {};

if(SC_liveVehicles >= SC_maxNumberofVehicles) exitWith {};

_vehiclesToSpawn = (SC_maxNumberofVehicles - SC_liveVehicles);

if(_vehiclesToSpawn > 0) then 
{ 
	diag_log format['[OCCUPATION:Vehicle] Started %2 currently active (max %3) spawning %1 extra vehicle(s) @ %4',_vehiclesToSpawn,SC_liveVehicles,SC_maxNumberofVehicles,time]; 
}
else
{
	diag_log format['[OCCUPATION:Vehicle] Started %2 currently active (max %3) @ %4',_vehiclesToSpawn,SC_liveVehicles,SC_maxNumberofVehicles,time];
};


_middle = worldSize/2;
_spawnCenter = [_middle,_middle,0];
_maxDistance = _middle;

if(_vehiclesToSpawn >= 1) then
{

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

	for "_j" from 1 to _vehiclesToSpawn do
	{
		private["_group"];
		_Location = _locations call BIS_fnc_selectRandom; 
		_position = position _Location;	
		_pos = [_position,10,100,5,0,20,0] call BIS_fnc_findSafePos;
		_spawnLocation = [_pos select 0, _pos select 1, 150];
		
		// Get position of nearest roads
		_nearRoads = _spawnLocation nearRoads 500;
		_nearestRoad = _nearRoads select 0;
		_nearestRoad = position (_nearRoads select 0);
		
		_group = createGroup east;
		_VehicleClassToUse = SC_VehicleClassToUse call BIS_fnc_selectRandom;
		_vehicleObject = [ [_nearestRoad], _group, "assault", "random", "bandit",_VehicleClassToUse ] call DMS_fnc_SpawnAIVehicle;

		// Get the AI to shut the fuck up :)
		enableSentences false;
		enableRadio false;
				
		diag_log format['[OCCUPATION:Vehicle] %1 spawned @ %2',_VehicleClassToUse,_spawnLocation];
		_vehicleObject addMPEventHandler ["mpkilled", "SC_liveVehicles = SC_liveVehicles - 1;"];
		_vehicleObject addMPEventHandler ["mphit", "_this call SC_fnc_repairVehicle;"];	
		
		_driverVeh = driver _vehicleObject;
		_driverVeh addMPEventHandler ["mpkilled", "_this call SC_fnc_driverKilled;"];
		_driverVeh setVariable ["SC_drivenVehicle", _vehicleObject,true];
		
		
		_vehicleObject setSpeedMode "LIMITED";
		_vehicleObject limitSpeed 60;
		_vehicleObject action ["LightOn", _vehicleObject];	
		[_group, _spawnLocation, 2000] call bis_fnc_taskPatrol;
		_group setBehaviour "AWARE";
		_group setCombatMode "RED";

		SC_liveVehicles = SC_liveVehicles + 1;	
		sleep 0.2;
	};
};

diag_log format['[OCCUPATION:Vehicle] Running'];