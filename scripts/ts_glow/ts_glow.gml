/// @description  ts_glow([colour])
/// @param [colour]
function ts_glow() {

	var str = "<<tag#"+string(ts.glow)+"|";

	if argument_count>=1
	    str+=string(argument[0])+"|"
	else
	    str+="-1|"
        
	str+=">>"

	return str;



}
