_vehicle	= _this select 0;
_vehicleDamage = getDammage _vehicle;

_wheels = ["HitLF2Wheel","HitLFWheel","HitRFWheel","HitRF2Wheel"];
_damagedWheels = 0;
{
	if ((_vehicle getHitPointDamage _x) >= 0.5) then
	{	
		_damagedWheels = _damagedWheels + 1;
	};
} forEach _wheels;

if(_damagedWheels >= 1 && alive (driver _vehicle)) then
{
	if(SC_infiSTAR_log) then 
	{
		_logDetail = format ["[OCCUPATION:repairVehicle]:: Unit %2 repairing vehicle at %1",time,_this select 0]; 
		['A3_EXILE_OCCUPATION',_logDetail] call FNC_A3_CUSTOMLOG;
	};

	_vehicle removeAllMPEventHandlers  "mphit";
	[_vehicle ] spawn 
	{
	 _vehicleToFix  = _this select 0;
	 _driverVeh = driver _vehicleToFix;
	_vehicleToFix forceSpeed 0;
	sleep 2;
	_driverVeh action ["Eject", _vehicleToFix];
	_driverVeh doWatch (position _vehicleToFix);
	_driverVeh playActionNow "medicStart";
	sleep 10;
	_driverVeh switchMove "";
	_driverVeh playActionNow "medicStart";
	sleep 4;
	_vehicleToFix setDamage 0;
	_driverVeh switchMove "";
	_driverVeh playActionNow "medicStop";
	sleep 2;
	_driverVeh assignAsDriver _vehicleToFix;
	_driverVeh moveInDriver _vehicleToFix;
	_vehicleToFix forceSpeed -1;
	_vehicleToFix addMPEventHandler ["mphit", "_this call SC_fnc_repairVehicle;"];	
	};		
};
