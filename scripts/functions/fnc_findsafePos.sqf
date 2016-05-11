_roadSpawn      = _this select 0;
_waterSpawn     = _this select 1;
_inWater        = 0;
_position       = [0,0,0];
_nearestRoad    = [0,0,0];

_pos        = if ((count _this)>2) then {_this select 2} else {false};
_maxDist    = if ((count _this)>2) then {_this select 3} else {false};

if(_waterSpawn) then
{
    _inWater = 2;    
}
else
{
    _inWater = 0;    
};

if(!_pos OR !_maxDist) then 
{
    _middle     = worldSize/2;
    _pos  = [_middle,_middle,0];
    _maxDist 	= _middle - 100; 
       
};
_validspot	= false;

while{!_validspot} do 
{
	sleep 0.2;
    _tempPosition = [_pos,0,_maxDist,15,_inWater,20,0] call BIS_fnc_findSafePos;
    _position = [_tempPosition select 0, _tempPosition select 1, 0];
    
    //diag_log format["BIS_fnc_findSafePos found position %8 using %1,%2,%3,%4,%5,%6,%7",_pos,0,_maxDist,15,_inWater,20,0,_position];
	_validspot = true;

    if(_roadSpawn) then
    {
        
        // Get position of nearest roads
        _nearRoads = _position nearRoads 500;
        if (count _nearRoads == 0 OR isNil "_nearRoads") then
        { 
            _validspot = false;  
            diag_log format["BIS_fnc_findSafePos no roads found near position  %1",_position];
        }
        else
        {
            _nearestRoad = _nearRoads select 0;
            _position = position _nearestRoad;
            diag_log format["BIS_fnc_findSafePos checking road found at %1",_position];        
        };        
    };
    
    // Check if position is near a blacklisted area
    {
        _blacklistPos       = _x select 0;
        _blacklistRadius    = _x select 1;
        _blacklistMap       = _x select 2;
        if(isNil "_blacklistPos" OR isNil "_blacklistRadius" OR isNil "_blacklistMap") exitWith 
        { 
            _logDetail = format["[OCCUPATION]:: Invalid blacklist position supplied check SC_blackListedAreas in your config.sqf"];
            [_logDetail] call SC_fnc_log;           
            
        };
        if (worldName == _blacklistMap) then
        {
            if(_position distance _blacklistPos < _blacklistRadius) exitWith
            {
                _validspot = false;                                        
            };
        };
            
    }forEach SC_blackListedAreas;
    
    //Check if near player base
	_nearBase = (nearestObjects [_position,["Exile_Construction_Flag_Static"],500]) select 0;
	if (!isNil "_nearBase") then { _validspot = false;  };	

    // Don't spawn AI near traders and spawn zones
    {
        switch (getMarkerType _x) do 
        {
            case "ExileSpawnZone":
            {
                if(_position distance (getMarkerPos _x) < SC_minDistanceToSpawnZones) exitWith
                {
                    _validspot = false;                        
                };
            };
            case "ExileTraderZone": 
            {
                if(_position distance (getMarkerPos _x) < SC_minDistanceToTraders) exitWith
                {
                    _validspot = false;                        
                };
            };
        };
    }
    forEach allMapMarkers; 
    
    // Don't spawn additional AI if there are players in range
    if([_position, 250] call ExileClient_util_world_isAlivePlayerInRange) exitwith { _validspot = false; };         
};

_position	