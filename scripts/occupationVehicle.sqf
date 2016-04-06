if (!isServer) exitWith {};

_logDetail = format['[OCCUPATION:Vehicle] Started'];
[_logDetail] call SC_fnc_log;

if(SC_liveVehicles >= SC_maxNumberofVehicles) exitWith 
{
    if(SC_extendedLogging) then 
    { 
        _logDetail = format['[OCCUPATION:Vehicle] End check %1 currently active (max %2) @ %3',SC_liveVehicles,SC_maxNumberofVehicles,time]; 
        [_logDetail] call SC_fnc_log;
    };   
};

_vehiclesToSpawn = (SC_maxNumberofVehicles - SC_liveVehicles);

if(SC_extendedLogging) then 
{ 
	if(_vehiclesToSpawn > 0) then 
	{ 
		_logDetail = format['[OCCUPATION:Vehicle] Started %2 currently active (max %3) spawning %1 extra vehicle(s) @ %4',_vehiclesToSpawn,SC_liveVehicles,SC_maxNumberofVehicles,time]; 
		[_logDetail] call SC_fnc_log;
	}
	else
	{
		_logDetail = format['[OCCUPATION:Vehicle] Started %2 currently active (max %3) @ %4',_vehiclesToSpawn,SC_liveVehicles,SC_maxNumberofVehicles,time];
		[_logDetail] call SC_fnc_log;
	};
	
};

_middle = worldSize/2;
_spawnCenter = [_middle,_middle,0];
_maxDistance = _middle;

if(_vehiclesToSpawn >= 1) then
{
	_useLaunchers = DMS_ai_use_launchers;
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
		_pos = [_position,10,250,5,0,20,0] call BIS_fnc_findSafePos;
		
		
		// Get position of nearest roads
		_nearRoads = _pos nearRoads 500;
		_nearestRoad = _nearRoads select 0;
		_nearestRoad = position (_nearRoads select 0);
		_spawnLocation = [_nearestRoad select 0, _pos select 1, 0];

		_group = createGroup east;
		_VehicleClassToUse = SC_VehicleClassToUse call BIS_fnc_selectRandom;
		_vehicle = createVehicle [_VehicleClassToUse, _spawnLocation, [], 0, "NONE"];
        _vehicle setVariable["vehPos",_spawnLocation,true];
        _vehicle setVariable["vehClass",_VehicleClassToUse,true];
        
        SC_liveVehicles = SC_liveVehicles + 1;
        SC_liveVehiclesArray = SC_liveVehiclesArray + [_vehicle];

		_vehicle setFuel 1;
		_vehicle engineOn true;
		_vehicle lock 0;			
		_vehicle setVehicleLock "UNLOCKED";
		_vehicle setVariable ["ExileIsLocked", 0, true];
		_vehicle setSpeedMode "LIMITED";
		_vehicle limitSpeed 60;
		_vehicle action ["LightOn", _vehicle];			
		
	
		_group addVehicle _vehicle;	
		_driver = [_group,_spawnLocation,"assault","random","bandit","Vehicle"] call DMS_fnc_SpawnAISoldier;
         sleep 0.5;	
        if(SC_debug) then
        {
            _tag = createVehicle ["Sign_Arrow_Green_F", position _driver, [], 0, "CAN_COLLIDE"];
            _tag attachTo [_driver,[0,0,0.6],"Head"];  
        };
        sleep 0.5;
		_driver setVariable ["DMS_AssignedVeh",_vehicle];
		_driver setVariable ["SC_drivenVehicle", _vehicle,true];	
        _driver action ["movetodriver", _vehicle];
        _driver assignAsDriver _vehicle;    
        _driver addMPEventHandler ["mpkilled", "_this call SC_fnc_driverKilled;"];
        
        _vehicle setVariable ["SC_assignedDriver", _driver,true];
        _vehicle setVariable ["SC_vehicleSpawnLocation", _spawnLocation,true];	
        _vehicle addEventHandler ["getin", "_this call SC_fnc_getIn;"];
		_vehicle addMPEventHandler ["mpkilled", "_this call SC_fnc_vehicleDestroyed;"];
		_vehicle addMPEventHandler ["mphit", "_this call SC_fnc_repairVehicle;"];	
        _group setBehaviour "CARELESS";
		_group setCombatMode "BLUE";    		
		sleep 0.2;
		_crewCount =
		{
			private _unit = [_group,_spawnLocation,"assault","random","bandit","Vehicle"] call DMS_fnc_SpawnAISoldier;
			_unit moveInTurret [_vehicle, _x];
			_unit setVariable ["DMS_AssignedVeh",_vehicle];
            _unit assignAsCargo _vehicle;
            sleep 0.2;
            _group setBehaviour "CARELESS";
		    _group setCombatMode "BLUE";
			true
		} count (allTurrets [_vehicle, true]);		
		

		// Get the AI to shut the fuck up :)
		enableSentences false;
		enableRadio false;

		if(SC_extendedLogging) then 
		{ 
			_logDetail = format['[OCCUPATION:Vehicle] %1 spawned @ %2',_VehicleClassToUse,_spawnLocation]; 
			[_logDetail] call SC_fnc_log;
		};

	
		[_group, _spawnLocation, 2000] call bis_fnc_taskPatrol;
		_group setBehaviour "AWARE";
		_group setCombatMode "RED";
		sleep 0.2;
		
		clearMagazineCargoGlobal _vehicle;
		clearWeaponCargoGlobal _vehicle;
		clearItemCargoGlobal _vehicle;

		_vehicle addMagazineCargoGlobal ["HandGrenade", (random 2)];
		_vehicle addItemCargoGlobal  ["ItemGPS", (random 1)];
		_vehicle addItemCargoGlobal  ["Exile_Item_InstaDoc", (random 1)];
		_vehicle addItemCargoGlobal ["Exile_Item_PlasticBottleFreshWater", 2 + (random 2)];
		_vehicle addItemCargoGlobal ["Exile_Item_EMRE", 2 + (random 2)];
		
		// Add weapons with ammo to the vehicle
		_possibleWeapons = 
		[			
			"arifle_MXM_Black_F",
			"arifle_MXM_F",
			"arifle_MX_SW_Black_F",
			"arifle_MX_SW_F",
			"LMG_Mk200_F",
			"LMG_Zafir_F"
		];
		_amountOfWeapons = 1 + (random 3);
		
		for "_i" from 1 to _amountOfWeapons do
		{
			_weaponToAdd = _possibleWeapons call BIS_fnc_selectRandom;
			_vehicle addWeaponCargoGlobal [_weaponToAdd,1];
		   
			_magazinesToAdd = getArray (configFile >> "CfgWeapons" >> _weaponToAdd >> "magazines");
			_vehicle addMagazineCargoGlobal [(_magazinesToAdd select 0),round random 3];
		};
	};
};

if(SC_extendedLogging) then 
{ 
	_logDetail = format['[OCCUPATION:Vehicle] End check %1 currently active (max %2) @ %3',SC_liveVehicles,SC_maxNumberofVehicles,time]; 
	[_logDetail] call SC_fnc_log;
};