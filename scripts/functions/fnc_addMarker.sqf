private["_newUniform","_newVest","_newHeadgear","_arrowClass"];

_side	= _this select 0;
_unit	= _this select 1;

if(_side == "survivor")  then 
{
    _unit addMPEventHandler ["mphit", "_this call SC_fnc_unitMPHit;"];
};
