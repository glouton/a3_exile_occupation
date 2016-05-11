// Logging function to use either infiSTAR logging function or server RPT

_logDetail = format["%1 %2",SC_occupationVersion,_this select 0];

if(SC_infiSTAR_log && !isNil "INFISTARVERSION") then
{
    ['A3_EXILE_OCCUPATION',_logDetail] call FNC_A3_CUSTOMLOG;    
}
else
{
    diag_log _logDetail;
};