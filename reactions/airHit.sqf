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

_heli = _this select 0;
_heliDamage = getDammage _heli;
_heliPosition = getPosATL _heli;
_heliHeight = getPosATL _heli select 2;
_crewEjected = _heli getVariable "SC_crewEjected";
if(SC_infiSTAR_log) then 
{
	_logDetail = format ["[OCCUPATION:Sky]:: Air unit %2 hit by %3 at %1 (damage: %4)",time,_this select 0,_this select 1,_heliDamage];
	['A3_EXILE_OCCUPATION',_logDetail] call FNC_A3_CUSTOMLOG;	
};
_ejectChance = round (random 100) + (_heliDamage * 100);

if(_heliDamage > 0 && _ejectChance > 70 && !_crewEjected) then
{
	_heli removeAllMPEventHandlers  "mphit";
	[_heli ] spawn 
	{
		_veh = _this select 0;
		{	
			if(SC_infiSTAR_log) then 
			{ 
				_heliPosition = getPosATL _veh;
				_logDetail = format ["[OCCUPATION:Sky]:: Air unit %2 ejecting passengers at %3 (time: %1)",time,_this select 0,_this select 1,_heliPosition]; 
				['A3_EXILE_OCCUPATION',_logDetail] call FNC_A3_CUSTOMLOG;	
			};
			_unit = _x select 0;
			if (isNull driver _veh) then
			{
                moveOut _unit;
                _parachute = "Steerable_Parachute_F" createVehicle getPos _unit;
                _parachute setDir (getDir _unit);
                _unit moveInDriver _parachute;
				_heliPosition = getPosATL _heli;
				_parachutePosition = [_heliPosition select 0, _heliPosition select 1, (_heliPosition select 2)-5];
				_parachute setPos _parachutePosition;
				sleep 0.1;
				 _parachute enableSimulationGlobal true;
			};
		} forEach (fullCrew _veh);

	};
	_heli setVariable ["SC_crewEjected", true,true];
	_target = _this select 1;
	_pilot = driver _heli;
	_group = group _pilot;
	_group reveal [_target,1.5];

	_destination = getPos _target;
	[_group, _destination, 250] call bis_fnc_taskPatrol;
	_group setBehaviour "COMBAT";
	_group setCombatMode "RED";


	_group allowFleeing 0;
	_group setBehaviour "AWARE";
	_group setSpeedMode "FULL";
	_group setCombatMode "RED";		
	_heli addMPEventHandler ["mphit", "_this call SC_fnc_airHit;"];	
};

if(_heliDamage >= 0.5) then
{
	if(SC_infiSTAR_log) then 
	{ 
		_logDetail = format ["[OCCUPATION:Sky]:: Air unit %2 damaged and force landing at %3 (time: %1)",time,_this select 0,_this select 1,_heliPosition];
		['A3_EXILE_OCCUPATION',_logDetail] call FNC_A3_CUSTOMLOG;
	};
	_heli removeAllMPEventHandlers  "mphit";
	_heli removeAllMPEventHandlers  "mpkilled";
	SC_liveHelis = SC_liveHelis - 1;
	_heli land "LAND";
	_heli setVehicleLock "UNLOCKED";
	_target = _this select 1;
	_pilot = driver _heli;
	_group = group _pilot;
	_group reveal [_target,1.5];

	_destination = getPos _target;
	[_group, _destination, 250] call bis_fnc_taskPatrol;
	_group setBehaviour "COMBAT";
	_group setCombatMode "RED";


	_group allowFleeing 0;
	_group setBehaviour "AWARE";
	_group setSpeedMode "FULL";
	_group setCombatMode "RED";	
};





	