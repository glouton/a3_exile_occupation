if (!isServer) exitWith {};

_logDetail = format ["[OCCUPATION Static]:: Starting Monitor"];
[_logDetail] call SC_fnc_log;

private["_wp","_wp2","_wp3"];

_middle 			    = worldSize/2;			
_spawnCenter 		    = [_middle,_middle,0];		// Centre point for the map
_maxDistance 		    = _middle;				    // Max radius for the map

_maxAIcount 			= SC_maxAIcount;
_minFPS 				= SC_minFPS;
_debug 				    = SC_debug;
_useLaunchers 		    = DMS_ai_use_launchers;
_scaleAI				= SC_scaleAI;

_statics 			    = SC_statics;               // details for the static spawns
_static 			    = [];

_currentPlayerCount = count playableUnits;
if(_currentPlayerCount > _scaleAI) then 
{
	_maxAIcount = _maxAIcount - (_currentPlayerCount - _scaleAI) ;
};


// Don't spawn additional AI if the server fps is below 8
if(diag_fps < _minFPS) exitWith 
{ 
    _logDetail = format ["[OCCUPATION Static]:: Held off spawning more AI as the server FPS is only %1",diag_fps]; 
    [_logDetail] call SC_fnc_log;    
};

_aiActive = {alive _x && (side _x == EAST OR side _x == WEST)} count allUnits;
if(_aiActive > _maxAIcount) exitWith 
{ 
    _logDetail = format ["[OCCUPATION Static]:: %1 active AI, so not spawning AI this time",_aiActive]; 
    [_logDetail] call SC_fnc_log;
};


{
	_currentStatic = _x;
	_spawnPosition = _currentStatic select 0;
	_aiCount = _currentStatic select 1;
	_radius = _currentStatic select 2;
	_staticSearch = _currentStatic select 3;
	
	_logDetail = format ["[OCCUPATION Static]:: Checking static spawn @ %1",_spawnPosition,_aiCount];
    [_logDetail] call SC_fnc_log;
	
	_okToSpawn = true;
	Sleep 0.1;

	while{_okToSpawn} do
	{			

		// Don't spawn additional AI if there are already AI in range
        _nearEastAI = { side _x == EAST AND _x distance _spawnPosition < 250 } count allUnits;
		if(_nearEastAI > 0) exitwith 
        { 
            _okToSpawn = false; 
            if(_debug) then 
            { 
                _logDetail = format ["[OCCUPATION Static]:: %1 already has %2 active AI patrolling",_spawnPosition,_nearEastAI];
                [_logDetail] call SC_fnc_log;
            };
        };

		// Don't spawn additional AI if there are players in range
		if([_spawnPosition, 250] call ExileClient_util_world_isAlivePlayerInRange) exitwith 
        { 
            _okToSpawn = false; 
            if(_debug) then 
            { 
                _logDetail = format ["[OCCUPATION Static]:: %1 has players too close",_spawnPosition];
                [_logDetail] call SC_fnc_log;
            }; 
        };
		
		if(_okToSpawn) then
		{
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			// Get AI to patrol the area
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			_groupRadius = _radius;
			_difficulty = "random";
			_side = "bandit";		
						
			DMS_ai_use_launchers = false;
			_initialGroup = [_spawnPosition, _aiCount, _difficulty, "assault", _side] call DMS_fnc_SpawnAIGroup;
            DMS_ai_use_launchers = _useLaunchers;
            _initialGroup setCombatMode "BLUE";
            _initialGroup setBehaviour "SAFE";

            _group = createGroup EAST;           
            _group setVariable ["DMS_LockLocality",nil];
            _group setVariable ["DMS_SpawnedGroup",true];
            _group setVariable ["DMS_Group_Side", _side];
            
            {	
                _unit = _x;           
                [_unit] joinSilent grpNull;
                [_unit] joinSilent _group;
                if(SC_debug) then
                {
                    _tag = createVehicle ["Sign_Arrow_F", position _unit, [], 0, "CAN_COLLIDE"];
                    _tag attachTo [_unit,[0,0,0.6],"Head"];  
                };                                   
            }foreach units _initialGroup;            
				
						
			// Get the AI to shut the fuck up :)
			enableSentences false;
			enableRadio false;
						
			if(!_staticSearch) then
			{
				[_group, _spawnPosition, _groupRadius] call bis_fnc_taskPatrol;
				_group setBehaviour "AWARE";
				_group setCombatMode "RED";
			}
			else
			{
				_buildings = _spawnPosition nearObjects ["building", _groupRadius];
				{
					_isEnterable = [_x] call BIS_fnc_isBuildingEnterable;
             
					if(_isEnterable) then
					{
                        _buildingPositions = [_x, 10] call BIS_fnc_buildingPositions;
                        _y = _x;
						// Find Highest Point
						_highest = [0,0,0];
						{
                            if(_x select 2 > _highest select 2) then
							{
								_highest = _x;
							};

						} foreach _buildingPositions;		
						_wpPosition = _highest;
						diag_log format ["Static Patrol %3 waypoint added - building: %1 position: %2",_y,_highest,_group];
						_i = _buildingPositions find _wpPosition;
						_wp = _group addWaypoint [_wpPosition, 0] ;
						_wp setWaypointBehaviour "AWARE";
						_wp setWaypointCombatMode "RED";
						_wp setWaypointCompletionRadius 1;
						_wp waypointAttachObject _y;
						_wp setwaypointHousePosition _i;
						_wp setWaypointType "SAD";

					};
				} foreach _buildings;
				if(count _buildings > 0 && !isNil "_wp") then
				{
					_wp setWaypointType "CYCLE";
				};			
			};

			//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			_logDetail = format ["[OCCUPATION Static]:: Spawning %1 AI in at %2 to patrol",_aiCount,_spawnPosition];
            [_logDetail] call SC_fnc_log;

			if(SC_mapMarkers && !isNil "_foundBuilding") then 
			{
				_marker = createMarker [format ["%1", _foundBuilding],_spawnPosition];
				_marker setMarkerShape "Icon";
				_marker setMarkerSize [3,3];
				_marker setMarkerType "mil_dot";
				_marker setMarkerBrush "Solid";
				_marker setMarkerAlpha 0.5;
				_marker setMarkerColor "ColorRed";
				_marker setMarkerText "Occupied Area (static)";	
			};
			
			_okToSpawn = false;			
		};	
	};
    
}forEach _statics;

_logDetail = "[OCCUPATION Static]: Ended";
[_logDetail] call SC_fnc_log;