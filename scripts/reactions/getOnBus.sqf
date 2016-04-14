// Triggered if a player gets on the public bus
// adds an addaction to stop the bus
_bus	= _this select 0;
_unit	= _this select 2;

if(isPlayer _unit) then
{
    _bustop = _unit addAction ["Stop the bus", { SC_StopTheBus = true } ];      
};

