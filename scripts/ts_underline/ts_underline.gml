/// @description  ts_underline([width, colour])
/// @param [width
/// @param  colour]
function ts_underline() {

	/*
	    width - width of underline, skip or set 0 to off underline
	    colour - colour of line, use ts.standart or -1 to set color of text
	*/


	var str = "<<tag#"+string(ts.unline)+"|";

	if argument_count>=1
	    str+=string(argument[0])+"|"
	else
	    str+="0|"

	if argument_count>=2
	    str+=string(argument[1])+"|"
	else
	    str+="-1|"
        
	str+=">>"

	return str;



}
