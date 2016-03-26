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

if (!isServer) exitWith {};

diag_log format ["[OCCUPATION:LootCrates]:: Starting Occupation Loot Crates"];

_middle 			= worldSize/2;
_spawnCenter 		= [_middle,_middle,0];
_max 			= _middle;
_numberofcrates 	= 3; // this is the number of crates that you want to spawn

if (worldName == 'Altis') then
{
	_spawnCenter 		= [15834.2,15787.8,0];
	_max 			= 16000;
	_numberofcrates 	= 6; // this is the number of crates that you want to spawn
};
if (worldName == 'Chernarus') then
{
	_spawnCenter 		= [7652.9634, 7870.8076,0];
	_max 			= 7500;
	_numberofcrates 	= 6; // this is the number of crates that you want to spawn
};
if (worldName == 'Taviana') then
{
	_spawnCenter 		= [12800, 12800,0];
	_max 			= 12800;
	_numberofcrates 	= 6; // this is the number of crates that you want to spawn
};

diag_log format['[OCCUPATION:LootCrates]::  worldname: %1 Centre: %2 radius: %3',worldName,_spawnCenter,_max];

_min 			= 0; 		// minimum distance from the center position (Number) in meters
_mindist 		= 15; 		// minimum distance from the nearest object (Number) in meters, ie. spawn at least this distance away from anything within x meters..
_water 			= 0; 		// water mode (Number)	0: cannot be in water , 1: can either be in water or not , 2: must be in water
_shoremode 		= 0; 		// 0: does not have to be at a shore , 1: must be at a shore
_marker 			= SC_occupyLootCratesMarkers; 		// Draw a green circle in which the crate will be spawned randomly

private['_position'];

for "_i" from 1 to _numberofcrates do
{
	_validspot 	= false;
	while{!_validspot} do 
	{
		sleep 0.2;
		_position = [_spawnCenter,_min,_max,_mindist,_water,20,_shoremode] call BIS_fnc_findSafePos;
		_validspot	= true;
		
		// Check for nearby spawn points and traders
		_nearestMarker = [allMapMarkers, _position] call BIS_fnc_nearestPosition;
		_posNearestMarker = getMarkerPos _nearestMarker;
		if(_position distance _posNearestMarker < 500) then { _validspot = false; };		
		
		//Check if near another crate site
		_nearOtherCrate = (nearestObjects [_position,["CargoNet_01_box_F"],500]) select 0;	
		if (!isNil "_nearOtherCrate") then { _validspot = false; };		
	
		//Check if near player base
        _nearBase = (nearestObjects [_position,["Exile_Construction_Flag_Static"],350]) select 0;
        if (!isNil "_nearBase") then { _validspot = false;  };	
	};	
	
	if (_marker) then 
	{
		_mapMarkerName = format ["loot_marker_%1", _i];
		_event_marker = createMarker [ format ["loot_marker_%1", _i], _position];
		_event_marker setMarkerColor "ColorGreen";
		_event_marker setMarkerAlpha 1;
		_event_marker setMarkerText "Gear Crate";
		_event_marker setMarkerType "loc_Tree";
		_event_marker setMarkerBrush "Vertical";
		_event_marker setMarkerSize [(3), (3)];
	};	

	//Infantry spawn using DMS
	_AICount = 1 + (round (random 2));	
	_ai_posx = _position select 0;
	_ai_posy = _position select 1;
	_ai_posz = 0;
	[[_ai_posx, _ai_posy, _ai_posz], _AICount, "random", "random", "bandit"] call DMS_fnc_SpawnAIGroup;

	diag_log text format ["[OCCUPATION:LootCrates]::  Creating crate %3 @ drop zone %1 with %2 guards",_position,_AICount,_i];
	
	_box = "CargoNet_01_box_F" createvehicle _position;
	clearMagazineCargoGlobal _box;
	clearWeaponCargoGlobal _box;
	clearItemCargoGlobal _box;
	
	_box enableRopeAttach false; 			// Stop people airlifting the crate
	_box setVariable ["permaLoot",true]; 	// stay until reset
	_box allowDamage false; 				// Prevent boxes to explode when spawning

	_box addItemCargoGlobal ["Exile_Melee_Axe", 1];
	_box addItemCargoGlobal ["Exile_Item_GloriousKnakworst", 1 + (random 2)];
	_box addItemCargoGlobal ["Exile_Item_PlasticBottleFreshWater", 1 + (random 2)];
	_box addItemCargoGlobal ["Exile_Item_Beer", 5 + (random 1)];
	_box addItemCargoGlobal ["Exile_Item_Laptop", (random 1)];
	_box addItemCargoGlobal ["Exile_Item_BaseCameraKit", (random 2)];
	_box addItemCargoGlobal ["Exile_Item_InstaDoc", 1 + (random 1)];
	_box addItemCargoGlobal ["Exile_Item_Matches", 1];
	_box addItemCargoGlobal ["Exile_Item_CookingPot", 1];
	_box addItemCargoGlobal ["Exile_Item_CodeLock", (random 1)];
	_box addItemCargoGlobal ["Exile_Item_MetalPole", 1];
	_box addItemCargoGlobal ["Exile_Item_LightBulb", 1];
	_box addItemCargoGlobal ["Exile_Item_FuelCanisterEmpty", 1];
	_box addItemCargoGlobal ["Exile_Item_WoodPlank", 1 + (random 8)];
	_box addItemCargoGlobal ["Exile_Item_woodFloorKit", 1 + (random 2)];
	_box addItemCargoGlobal ["Exile_Item_WoodWindowKit", 1 + (random 1)];
	_box addItemCargoGlobal ["Exile_Item_WoodDoorwayKit", 1 + (random 1)];
	_box addItemCargoGlobal ["Exile_Item_WoodFloorPortKit", 1 + (random 2)];

};

