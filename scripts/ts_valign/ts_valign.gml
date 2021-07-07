/// @description  ts_valign(valign)
/// @param valign
function ts_valign(argument0) {

	/*
	    valign - valign of string, try different values to learn it
	        fa_top
	        fa_center
	        fa_bottom
	*/


	var str = "<<tag#"+string(ts.valign)+"|", val;

	if argument0=fa_top val=0
	else if argument0=fa_center val=0.5
	else if argument0=fa_bottom val=1

	str+=string(val)+"|>>"

	return str;



}
