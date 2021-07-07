/// @description  ts_wave([speed, strong_in_pixels])
/// @param [speed
/// @param  strong_in_pixels]
function ts_wave() {

	// it works only with ts_effects(true)



	var str = "<<tag#"+string(ts.wave)+"|";

	if argument_count>=1
	    str+=string(argument[0])+"|"
	else
	    str+="0|"

	if argument_count>=2
	    str+=string(argument[1])+"|"
	else
	    str+="0|"
        
	str+=">>"

	return str;



}
