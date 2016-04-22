if (!isServer) exitWith {};

_logDetail = format ["[OCCUPATION:publicBus]:: Starting @ %1",time];
[_logDetail] call SC_fnc_log;

if( count SC_occupyPublicBusStartPos == 0) then 
{
    //if(worldName == 'Namalsk') then { _spawnCenter = [6400,6400,0]; } else
    //{
        _middle 		    = worldSize/2;			
        _spawnCenter 	    = [_middle,_middle,0];         
    //};
    SC_occupyPublicBusStartPos = _spawnCenter;
};

_logDetail = format ["[OCCUPATION:publicBus]:: Spawning near map centre %1 @ %2",SC_occupyPublicBusStartPos,time];
[_logDetail] call SC_fnc_log;

_positionOfBus = [SC_occupyPublicBusStartPos,0,500,25,0,10,0] call BIS_fnc_findSafePos;

// Get position of nearest roads
_nearRoads = _positionOfBus nearRoads 2000;
_nearestRoad = _nearRoads select 0;
_nearestRoadPos = position (_nearRoads select 0);
_spawnLocation = [_nearestRoadPos select 0, _nearestRoadPos select 1, 0];

// Create the busDriver and ensure he doest react to gunfire or being shot at.
_group = createGroup resistance;
_group setCombatMode "BLUE";

"Exile_Trader_CommunityCustoms" createUnit [_spawnLocation, _group, "busDriver = this; this disableAI 'AUTOTARGET'; this disableAI 'TARGET'; this disableAI 'SUPPRESSION'; "];

busDriver allowDamage false; 
removeGoggles busDriver;
busDriver forceAddUniform "U_IG_Guerilla3_1";
busDriver addVest "V_TacVest_blk_POLICE";
busDriver addBackpack "B_FieldPack_oli";
busDriver addHeadgear "H_Cap_blk";
busDriver setCaptive true;

// Spawn busDrivers Vehicle
_publicBus = createVehicle [SC_occupyPublicBusClass, _spawnLocation, [], 0, "CAN_COLLIDE"];
SC_publicBusArray = SC_publicBusArray + [_publicBus];
_publicBus setVariable ["SC_assignedDriver", busDriver,true];
_publicBus setVariable ["SC_publicBus", true,true];
_publicBus setVariable ["SC_vehicleSpawnLocation", _spawnLocation,true];
_publicBus addEventHandler ["getin", "_this call SC_fnc_getOnBus;"];
_publicBus addEventHandler ["getout", "_this call SC_fnc_getOffBus;"];


_group addVehicle _publicBus;	
clearBackpackCargoGlobal _publicBus;
clearItemCargoGlobal _publicBus;
clearMagazineCargoGlobal _publicBus;
clearWeaponCargoGlobal _publicBus;
_publicBus setVariable ["ExileIsPersistent", false];
_publicBus setVariable["vehPos",_spawnLocation,true];
_publicBus setFuel 1;

_logDetail = format['[OCCUPATION:publicBus] Vehicle spawned @ %1',_spawnLocation];
[_logDetail] call SC_fnc_log;

_publicBus addEventHandler ["HandleDamage", { _amountOfDamage = 0; _amountOfDamage }];

busDriver assignasdriver _publicBus;
busDriver moveInDriver _publicBus;
[busDriver] orderGetin true;
_publicBus lockDriver true;
	
{
	_markerName = _x;
	_markerPos = getMarkerPos _markerName;
	if (markerType _markerName == "ExileTraderZone" OR markerType _markerName == "o_unknown") then 
	{
		_wp = _group addWaypoint [_markerPos, 100];
		_wp setWaypointType "MOVE";
		_wp setWaypointBehaviour "CARELESS";
		_wp setWaypointspeed "LIMITED"; 
	};
  
} forEach allMapMarkers;

// Add a final CYCLE
_wp = _group addWaypoint [_spawnLocation, 100];
_wp setWaypointType "CYCLE";
_wp setWaypointBehaviour "CARELESS";
_wp setWaypointspeed "LIMITED"; 

 
_busPos = position _publicBus;
_mk = createMarker ["busLocation",_busPos];
"busLocation" setMarkerType "mil_warning";
"busLocation" setMarkerText "Public Bus";

diag_log format['[OCCUPATION:publicBus] Running'];
busDriver = _publicBus getVariable "SC_assignedDriver";

// Make busDriver stop when players near him.
while {true} do
{
    
    _pos = position _publicBus;
    _mk setMarkerPos _pos;
    _nearPlayers = (count (_pos nearEntities [['Exile_Unit_Player'],25]));

    if (_nearPlayers >= 1) then
    {
        uiSleep 0.5;
        _publicBus setFuel 0;
        busDriver disableAI "MOVE";
        _publicBus animateDoor ["Doors_1", 1];
        _publicBus animateDoor ["Doors_2", 1];
        _publicBus animateDoor ["Doors_3", 1];
        uiSleep 3;
    }
    else
    {	
        _publicBus setFuel 1;
        _publicBus animateDoor ["Doors_1", 0];
        _publicBus animateDoor ["Doors_2", 0];
        _publicBus animateDoor ["Doors_3", 0];
        uiSleep 3;
        busDriver enableAI "MOVE";
        if(!Alive busDriver) exitWith {};
    };
    uiSleep 5;   
};		


