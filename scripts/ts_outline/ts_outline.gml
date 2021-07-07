/// @description  ts_outline(bool, [colour])
/// @param bool
/// @param  [colour]
function ts_outline() {

	/*
	    bool - true or false
	    colour - colour of outline
	*/


	var str = "<<tag#"+string(ts.outline)+"|"+string(argument[0])+"|";

	if argument_count>=2
	    str+=string(argument[1])+"|"
	else
	    str+=string(c_black)+"|"
    
	str+="1|"
    
	str+=">>"

	return str;



}
