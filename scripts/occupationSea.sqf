_logDetail = format['[OCCUPATION:Sea] Started'];
[_logDetail] call SC_fnc_log;

if (!isServer) exitWith {};

if(SC_liveBoats >= SC_maxNumberofBoats) exitWith 
{
    if(SC_extendedLogging) then 
    { 
        _logDetail = format['[OCCUPATION:Sea] End check %1 currently active (max %2) @ %3',SC_liveBoats,SC_maxNumberofBoats,time]; 
        [_logDetail] call SC_fnc_log;
    };    
};

_vehiclesToSpawn = (SC_maxNumberofBoats - SC_liveBoats);
_middle = worldSize/2;
_spawnCenter = [_middle,_middle,0];
_maxDistance = _middle;

for "_i" from 1 to _vehiclesToSpawn do
{
	private["_group"];

	_spawnLocation = [ 250, 0, 1, 1000, 1000, 1000, 1000, 1000, true, true ] call DMS_fnc_findSafePos;
    //_spawnLocation = [(_pos), 80, 10] call ExileClient_util_world_findWaterPosition;
	_group = createGroup east;
	_BoatClassToUse = SC_BoatClassToUse call BIS_fnc_selectRandom;
	_vehicle1 = [ [_spawnLocation], _group, "assault", "difficult", "bandit", _BoatClassToUse ] call DMS_fnc_SpawnAIVehicle;
    _vehicle1 setPosASL _spawnLocation;
    _vehicle1 setVariable["vehPos",_spawnLocation,true];
    _vehicle1 setVariable["vehClass",_BoatClassToUse,true];
    _vehicle1 setVariable ["SC_vehicleSpawnLocation", _spawnLocation,true];
    
    // Remove the overpowered weapons from boats
    _vehicle1 removeWeaponTurret  ["HMG_01",[0]];
    _vehicle1 removeWeaponTurret  ["GMG_40mm",[0]];
	
    SC_liveBoats = SC_liveBoats + 1;
    SC_liveBoatsArray = SC_liveBoatsArray + [_vehicle1];
    
	_vehicle1 setVehicleLock "UNLOCKED";
	_vehicle1 setVariable ["ExileIsLocked", 0, true];
	if(SC_infiSTAR_log) then 
	{ 
		_logDetail = format['[OCCUPATION:Sea] %1 spawned @ %2',_BoatClassToUse,_spawnLocation];	
		[_logDetail] call SC_fnc_log;
	};
	_vehicle1 setVehiclePosition [_spawnLocation, [], 0, "NONE"];
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

	
	[_group, _spawnLocation, 4000] call bis_fnc_taskPatrol;
	_group setBehaviour "CARELESS";
	_group setCombatMode "RED";
	_vehicle1 addEventHandler ["getin", "_this call SC_fnc_claimVehicle;"];	
	_vehicle1 addMPEventHandler ["mpkilled", "_this call SC_fnc_vehicleDestroyed;"];
	_vehicle1 addMPEventHandler ["mphit", "_this call SC_fnc_boatHit;"];
	_vehicle1 setVariable ["SC_crewEjected", false,true];	
	sleep 0.2;
	
};


_logDetail = format['[OCCUPATION:Sea] Running'];
[_logDetail] call SC_fnc_log;