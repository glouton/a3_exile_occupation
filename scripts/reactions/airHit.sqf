_heli = _this select 0;
_heli removeAllMPEventHandlers  "mphit";
_heliDamage = getDammage _heli;
_heliPosition = getPosATL _heli;
_heliHeight = getPosATL _heli select 2;
_crewEjected = _heli getVariable "SC_crewEjected";

_damageLimit 		= 0.2;
_engineDamage 		= false;
_fueltankDamage 	= false;

if(SC_extendedLogging) then 
{
	_logDetail = format ["[OCCUPATION:Sky]:: Air unit %2 hit by %3 at %1 (damage: %4)",time,_this select 0,_this select 1,_heliDamage];
	[_logDetail] call SC_fnc_log;	
};
_ejectChance = round (random 100) + (_heliDamage * 100);


_essentials = [ "HitAvionics","HitEngine1","HitEngine2","HitEngine","HitHRotor","HitVRotor","HitTransmission",
                "HitHydraulics","HitGear","HitHStabilizerL1","HitHStabilizerR1","HitVStabilizer1","HitFuel"];

_damagedEssentials = 0;
{
	if ((_heli getHitPointDamage _x) > 0) then
	{	
		_damage = _heli getHitPointDamage _x;
        if(SC_extendedLogging) then 
        {
            _logDetail = format ["[OCCUPATION:Sky]:: Heli %1 checking part %2 (damage: %4) @ %3",_heli, _x, time,_damage]; 
            [_logDetail] call SC_fnc_log;
        };        
		if(_damage > 0) then { _damagedEssentials = _damagedEssentials + 1; };
	};
} forEach _essentials;


if(_damagedEssentials > 0 && !_crewEjected && _ejectChance > 80) then
{
	
	[_heli ] spawn 
	{
		_veh = _this select 0;
		{	
			if(SC_extendedLogging) then 
			{ 
				_heliPosition = getPosATL _veh;
				_logDetail = format ["[OCCUPATION:Sky]:: Air unit %2 ejecting passengers at %3 (time: %1)",time,_this select 0,_this select 1,_heliPosition]; 
				[_logDetail] call SC_fnc_log;	
			};
			_unit = _x select 0;
			if (isNull driver _veh) then
			{
				_unit action ["EJECT", _veh];
			};
		} forEach (fullCrew _veh);

	};
	_heli setVariable ["SC_crewEjected", true,true];
	_target = _this select 1;
	_pilot = driver _heli;
	_group = group _heli;
	_group reveal [_target,1.5];

	_destination = getPos _target;
	[_group, _destination, 250] call bis_fnc_taskPatrol;
	_group allowFleeing 0;
	_group setBehaviour "AWARE";
	_group setSpeedMode "FULL";
	_group setCombatMode "RED";	
	_heli addMPEventHandler ["mphit", "_this call SC_fnc_airHit;"];	
};
	

if(_heliDamage > 0.5 && _damagedEssentials > 0) then
{
	if(SC_extendedLogging) then 
	{ 
		_logDetail = format ["[OCCUPATION:Sky]:: Air unit %2 damaged and force landing at %3 (time: %1)",time,_this select 0,_this select 1,_heliPosition];
		[_logDetail] call SC_fnc_log;
	};
	_heli removeAllMPEventHandlers  "mphit";
	_heli removeAllMPEventHandlers  "mpkilled";
    _currentHeliPos = getPos _heli;
    _destination = [_currentHeliPos, 1, 150, 10, 0, 20, 0] call BIS_fnc_findSafePos;
	SC_liveHelis = SC_liveHelis - 1;
	_heli land "LAND";
	_heli setVehicleLock "UNLOCKED";
	_target = _this select 1;
	_pilot = driver _heli;
	_group = group _heli;
	_group reveal [_target,1.5];

	_group allowFleeing 0;
	_wp = _group addWaypoint [_destination, 0] ;
	_wp setWaypointFormation "Column";
	_wp setWaypointBehaviour "COMBAT";
	_wp setWaypointCombatMode "RED";
	_wp setWaypointCompletionRadius 1;
	_wp setWaypointType "SAD";
	[_group, _destination, 250] call bis_fnc_taskPatrol;
    _group setBehaviour "COMBAT";
    _group setCombatMode "RED";
};