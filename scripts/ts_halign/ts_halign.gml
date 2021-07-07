/// @description  ts_halign(halign)
/// @param halign
function ts_halign(argument0) {

	/*
	    halign - halign of current line
	*/


	var str = "<<tag#"+string(ts.halign)+"|", val;

	if argument0=fa_left val=0
	else if argument0=fa_center val=0.5
	else if argument0=fa_right val=1

	str+=string(val)+"|>>"

	return str;



}
