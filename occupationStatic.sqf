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

private["_wp","_wp2","_wp3"];

if (!isServer) exitWith {};
diag_log format ["[OCCUPATION Static]:: Starting Monitor"];

_middle 			= worldSize/2;			
_spawnCenter 		= [_middle,_middle,0];		// Centre point for the map
_maxDistance 		= _middle;				// Max radius for the map

_maxAIcount 			= SC_maxAIcount;
_minFPS 				= SC_minFPS;
_debug 				= SC_debug;
_useLaunchers 		= DMS_ai_use_launchers;
_scaleAI				= SC_scaleAI;

_statics 			= SC_statics; // details for the static spawns
_static 			= [];

_currentPlayerCount = count playableUnits;
if(_currentPlayerCount > _scaleAI) then 
{
	_maxAIcount = _maxAIcount - (_currentPlayerCount - _scaleAI) ;
};


// Don't spawn additional AI if the server fps is below 8
if(diag_fps < _minFPS) exitWith { diag_log format ["[OCCUPATION Static]:: Held off spawning more AI as the server FPS is only %1",diag_fps]; };

_aiActive = count(_spawnCenter nearEntities ["O_recon_F", _maxDistance+1000]);
if(_aiActive > _maxAIcount) exitWith { diag_log format ["[OCCUPATION Static]:: %1 active AI, so not spawning AI this time",_aiActive]; };

for [{_i = 0},{_i < (count _statics)},{_i =_i + 1}] do
{
	_currentStatic = _statics select _i;
	_spawnPosition = _currentStatic select 0;
	_aiCount = _currentStatic select 1;
	_radius = _currentStatic select 2;
	_staticSearch = _currentStatic select 3;
	_underground = _currentStatic select 4;
	
	diag_log format ["[OCCUPATION Static]:: Adding %2 AI to static spawn @ %1",_spawnPosition,_aiCount];
	
	_okToSpawn = true;
	Sleep 0.1;

	while{_okToSpawn} do
	{			

		// Don't spawn additional AI if there are already AI in range
		_aiNear = count(_spawnPosition nearEntities ["O_recon_F", 125]);
		if(_aiNear > 0) exitwith { _okToSpawn = false; if(_debug) then { diag_log format ["[OCCUPATION Static]:: %1 already has %2 active AI patrolling",_spawnPosition,_aiNear];}; };

		// Don't spawn additional AI if there are players in range
		if([_spawnPosition, 1] call ExileClient_util_world_isAlivePlayerInRange) exitwith { _okToSpawn = false; if(_debug) then { diag_log format ["[OCCUPATION Static]:: %1 has players too close",_spawnPosition];}; };
		
		if(_okToSpawn) then
		{
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			// Get AI to patrol the area
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			_groupRadius = _radius;
			_difficulty = "random";
			_side = "bandit";		
						
			DMS_ai_use_launchers = false;
			_group = [_spawnPosition, _aiCount, _difficulty, "random", _side] call DMS_fnc_SpawnAIGroup;
			[ _group,_spawnPosition,_difficulty,"AWARE" ] call DMS_fnc_SetGroupBehavior;
			DMS_ai_use_launchers = true;						
						
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
				
				
				_buildings = _spawnPosition nearObjects ["house", _groupRadius];
				{
					_buildingPositions = [_x, 10] call BIS_fnc_buildingPositions;
					if(count _buildingPositions > 0) then
					{

						// Find Highest Point
						_highest = [0,0,0];
						{
							if(_x select 2 > _highest select 2) then
							{
								_highest = _x;
							};

						} foreach _buildingPositions;		
						_spawnPosition = _highest;
						
						_i = _buildingPositions find _spawnPosition;
						_wp = _group addWaypoint [_spawnPosition, 0] ;
						_wp setWaypointFormation "Column";
						_wp setWaypointBehaviour "DESTROY";
						_wp setWaypointCombatMode "RED";
						_wp setWaypointCompletionRadius 1;
						_wp waypointAttachObject _x;
						_wp setwaypointHousePosition _i;
						_wp setWaypointType "MOVE";

					};
				} foreach _buildings;
				if(count _buildings > 0 ) then
				{
					_wp setWaypointType "CYCLE";
				};			
			};				
			
			
			
		
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			diag_log format ["[OCCUPATION Static]:: Spawning %1 AI in at %2 to patrol",_aiCount,_spawnPosition];

			if(SC_mapMarkers) then 
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
    
};
diag_log "[OCCUPATION Static]: Ended";