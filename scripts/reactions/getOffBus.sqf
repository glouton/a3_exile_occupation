// Triggered if a player gets off the public bus
// removes the addaction to stop the bus
_bus	= _this select 0;
_unit	= _this select 2;

if(isPlayer _unit) then
{
    _bus removeAction SC_bustop;      
};