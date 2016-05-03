_logDetail = format ["[OCCUPATION:Unstick]:: Initialised at %1",time];
[_logDetail] call SC_fnc_log;

{
    if(!isNull _x) then
    {
        _logDetail = format ["[OCCUPATION:Unstick]:: Air: %1 is active",_x];
        [_logDetail] call SC_fnc_log; 
        _x setFuel 1; 
        [_x] call SC_fnc_comeUnstuck;
        sleep 5;         
    }
    else
    {
        SC_liveHelis = SC_liveHelis - 1;
        SC_liveHelisArray = SC_liveHelisArray - [_x];          
    };
 
}forEach SC_liveHelisArray;

{
    if(!isNull _x) then
    {
        _logDetail = format ["[OCCUPATION:Unstick]:: Land: %1 is active",_x];
        [_logDetail] call SC_fnc_log; 
        _x setFuel 1; 
        [_x] call SC_fnc_comeUnstuck;
        sleep 5;     
    }
    else
    {
        SC_liveVehicles = SC_liveVehicles - 1;
        SC_liveVehiclesArray = SC_liveVehiclesArray - [_x];         
    };  
}forEach SC_liveVehiclesArray;

{
    if(!isNull _x) then
    {
        _logDetail = format ["[OCCUPATION:Unstick]:: Sea: %1 is active",_x];
        [_logDetail] call SC_fnc_log; 
        _x setFuel 1;      
        [_x] call SC_fnc_comeUnstuck; 
        sleep 5; 
    }
    else
    {
        SC_liveBoats = SC_liveBoats - 1;
        SC_liveBoatsArray = SC_liveBoatsArray - [_x];        
    }; 
}forEach SC_liveBoatsArray;


_logDetail = format ["[OCCUPATION:Unstick]:: Finished at %1",time];
[_logDetail] call SC_fnc_log;