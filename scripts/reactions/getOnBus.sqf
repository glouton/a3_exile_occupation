// Triggered if a player gets on the public bus
// adds an addaction to stop the bus
_bus	= _this select 0;
_unit	= _this select 2;

if(isPlayer _unit) then
{
    hint "You got on the bus";
    SC_bustop = _bus addAction ["Stop the bus", { SC_StopTheBus = true } ];    
};

