private["_newUniform","_newVest","_newHeadgear","_arrowClass"];

_side	= _this select 0;
_unit	= _this select 1;

removeUniform _unit;
removeVest _unit;
removeHeadgear _unit;

switch (_side) do 
{
    case "survivor":
    {
        _newUniform = SC_SurvivorUniforms call BIS_fnc_selectRandom;
        _newVest = SC_SurvivorVests call BIS_fnc_selectRandom; 
        _newHeadgear = SC_SurvivorHeadgear call BIS_fnc_selectRandom;
        _arrowClass = "Sign_Arrow_Green_F"; 
        _unit addMPEventHandler ["mphit", "_this call SC_fnc_unitMPHit;"];        
    };
    case "bandit":
    {
        _newUniform = SC_BanditUniforms call BIS_fnc_selectRandom;
        _newVest = SC_BanditVests call BIS_fnc_selectRandom; 
        _newHeadgear = SC_BanditHeadgear call BIS_fnc_selectRandom;
        _arrowClass = "Sign_Arrow_F";      
    };    
};
sleep 0.1;
_unit forceAddUniform _newUniform;  
if(!isNil "_newVest") then { _unit addVest _newVest; };
if(!isNil "_newHeadgear") then { _unit addHeadgear _newHeadgear; };
_backpackChance = round (random 100);

if(_backpackChance < 40) then { removeBackpackGlobal _unit; };

if(SC_debug) then
{
    _tag = createVehicle [_arrowClass, position _unit, [], 0, "CAN_COLLIDE"];
    _tag attachTo [_unit,[0,0,0.6],"Head"];  
}; 
_unit addMPEventHandler ["mpkilled", "_this call SC_fnc_unitMPKilled;"]; 