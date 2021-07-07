/// @description  ts_shake([strong_in_pixels])
/// @param [strong_in_pixels]
function ts_shake() {

	// it works only with ts_effects(true)


	var str = "<<tag#"+string(ts.shake)+"|";

	if argument_count>=1
	    str+=string(argument[0])+"|"
	else
	    str+="0|"
        
	str+=">>"

	return str;



}
