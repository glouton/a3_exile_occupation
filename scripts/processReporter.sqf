 _logDetail = "=======================================================================================================";
['A3_EXILE_PROCESSREPORTER',_logDetail] call FNC_A3_CUSTOMLOG;
 _logDetail = format['[processReporter] Started @ %4 : [FPS: %1|PLAYERS: %2|THREADS: %3]',diag_fps,count allplayers,count diag_activeSQFScripts,time];
['A3_EXILE_PROCESSREPORTER',_logDetail] call FNC_A3_CUSTOMLOG;
_logDetail = "=======================================================================================================";
['A3_EXILE_PROCESSREPORTER',_logDetail] call FNC_A3_CUSTOMLOG;

{
	_logDetail = format ["[processReporter] %1 @ %2",_x,time];
	['A3_EXILE_PROCESSREPORTER',_logDetail] call FNC_A3_CUSTOMLOG;
} forEach diag_activeSQFScripts;

_logDetail =  format ["[processReporter] Ended @ %1",time];
['A3_EXILE_PROCESSREPORTER',_logDetail] call FNC_A3_CUSTOMLOG;