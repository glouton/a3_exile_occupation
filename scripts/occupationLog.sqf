// Logging function to use either infiSTAR logging function or server RPT

_logDetail = _this select 0;

if(isNil "INFISTARVERSION") then { SC_infiSTAR_log = false; };

if(SC_infiSTAR_log) then
{
    ['A3_EXILE_OCCUPATION',_logDetail] call FNC_A3_CUSTOMLOG;    
}
else
{
    diag_log _logDetail;
};