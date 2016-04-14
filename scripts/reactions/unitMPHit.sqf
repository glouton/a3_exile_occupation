// Get the variables from the event handler
_unit 			= _this select 0;
_aggressor 	    = _this select 1;
_damage         = _this select 2;

// remove the eventhandler to stop it triggering multiple times simultaneously
_unit removeAllMPEventHandlers  "mphit";

if (side _aggressor == RESISTANCE) then 
{
    // Make victim and his group aggressive to their attacker
    _group = group _unit;
    _unit addRating -999999; 
    _group reveal [_aggressor, 2.5]; 
    _group move (position _aggressor); 
    diag_log format["::testing:: unit %1 damaged by %2",_unit,_aggressor];
 
};

if(alive _unit) then 
{ 
    // reapply the eventhandler
    _unit addMPEventHandler ["mphit", "_this call SC_fnc_unitMPHit;"];
};
