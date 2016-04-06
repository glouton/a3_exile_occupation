_logDetail = format['[OCCUPATION:Sky] Started'];
[_logDetail] call SC_fnc_log;

if (!isServer) exitWith {};

if(SC_liveHelis >= SC_maxNumberofHelis) exitWith 
{
    if(SC_extendedLogging) then 
    { 
        _logDetail = format['[OCCUPATION:Sky] End check %1 currently active (max %2) @ %3',SC_liveHelis,SC_maxNumberofHelis,time]; 
        [_logDetail] call SC_fnc_log;
    };    
};

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
	_pos = position _Location;	
	_position = [_pos select 0, _pos select 1, 300];
	_spawnLocation = [_position,10,100,5,0,20,0] call BIS_fnc_findSafePos;
	_height = 250 + (round (random 200));
	_helispawnLocation = [_spawnLocation select 0, _spawnLocation select 1, _height];
   
	_group = createGroup east;
	_HeliClassToUse = SC_HeliClassToUse call BIS_fnc_selectRandom;
	_vehicle1 = [ [_helispawnLocation], _group, "assault", "difficult", "bandit", _HeliClassToUse ] call DMS_fnc_SpawnAIVehicle;
    _vehicle1 setVariable["vehPos",_helispawnLocation,true];
    _vehicle1 setVariable["vehClass",_HeliClassToUse,true];
    _vehicle1 setVariable ["SC_vehicleSpawnLocation", _spawnLocation,true];
    {
        _unit = _x;
        removeBackpackGlobal _unit;
        _unit addBackpackGlobal "B_Parachute";
    }forEach units _group;
	
    SC_liveHelis = SC_liveHelis + 1;
    SC_liveHelisArray = SC_liveHelisArray + [_vehicle1];
    
	_vehicle1 setVehicleLock "UNLOCKED";
	_vehicle1 setVariable ["ExileIsLocked", 0, true];
	if(SC_infiSTAR_log) then 
	{ 
		_logDetail = format['[OCCUPATION:Sky] %1 spawned @ %2',_HeliClassToUse,_spawnLocation];	
		[_logDetail] call SC_fnc_log;
	};
	_vehicle1 setVehiclePosition [_spawnLocation, [], 0, "FLY"];
	_vehicle1 setVariable ["vehicleID", _spawnLocation, true];  
	_vehicle1 setFuel 1;
	_vehicle1 setDamage 0;
	_vehicle1 engineOn true;
	_vehicle1 flyInHeight 150;
	sleep 0.2;

	
	clearMagazineCargoGlobal _vehicle1;
	clearWeaponCargoGlobal _vehicle1;
	clearItemCargoGlobal _vehicle1;

	_vehicle1 addMagazineCargoGlobal ["HandGrenade", (random 2)];
	_vehicle1 addItemCargoGlobal  ["ItemGPS", (random 1)];
	_vehicle1 addItemCargoGlobal  ["Exile_Item_InstaDoc", (random 1)];
	_vehicle1 addItemCargoGlobal ["Exile_Item_PlasticBottleFreshWater", 2 + (random 2)];
	_vehicle1 addItemCargoGlobal ["Exile_Item_EMRE", 2 + (random 2)];
	
	// Add weapons with ammo to the vehicle
	_possibleWeapons = 
	[			
		"arifle_MXM_Black_F",
		"arifle_MXM_F",
		"srifle_DMR_01_F",
		"srifle_DMR_02_camo_F",
		"srifle_DMR_02_F",
		"srifle_DMR_02_sniper_F",
		"srifle_DMR_03_F",
		"srifle_DMR_03_khaki_F",
		"srifle_DMR_03_multicam_F",
		"srifle_DMR_03_tan_F",
		"srifle_DMR_03_woodland_F",
		"srifle_DMR_04_F",
		"srifle_DMR_04_Tan_F",
		"srifle_DMR_05_blk_F",
		"srifle_DMR_05_hex_F",
		"srifle_DMR_05_tan_f",
		"srifle_DMR_06_camo_F",
		"srifle_DMR_06_olive_F",
		"srifle_EBR_F",
		"srifle_GM6_camo_F",
		"srifle_GM6_F",
		"srifle_LRR_camo_F",
		"srifle_LRR_F"
	];
	_amountOfWeapons = 1 + (random 3);
	
	for "_i" from 1 to _amountOfWeapons do
	{
		_weaponToAdd = _possibleWeapons call BIS_fnc_selectRandom;
		_vehicle1 addWeaponCargoGlobal [_weaponToAdd,1];
	   
		_magazinesToAdd = getArray (configFile >> "CfgWeapons" >> _weaponToAdd >> "magazines");
		_vehicle1 addMagazineCargoGlobal [(_magazinesToAdd select 0),round random 3];
	};

	
	[_group, _spawnLocation, 2000] call bis_fnc_taskPatrol;
	_group setBehaviour "CARELESS";
	_group setCombatMode "RED";
	_vehicle1 addEventHandler ["getin", "_this call SC_fnc_claimVehicle;"];	
	_vehicle1 addMPEventHandler ["mpkilled", "_this call SC_fnc_vehicleDestroyed;"];
	_vehicle1 addMPEventHandler ["mphit", "_this call SC_fnc_airHit;"];
	_vehicle1 setVariable ["SC_crewEjected", false,true];	
	sleep 0.2;
	
};


_logDetail = format['[OCCUPATION:Sky] Running'];
[_logDetail] call SC_fnc_log;