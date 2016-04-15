// Triggered if a player gets off the public bus
// removes the addaction to stop the bus
_bus	= _this select 0;
_unit	= _this select 2;

_bus setFuel 0;
_busDriver = driver _bus;
_busDriver disableAI "MOVE";
_bus animateDoor ["Doors_1", 1];
_bus animateDoor ["Doors_2", 1];
_bus animateDoor ["Doors_3", 1];