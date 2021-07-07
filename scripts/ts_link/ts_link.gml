/// @description  ts_link(url_or_script, colour_moveon, colour_press)
/// @param url_or_script
/// @param  colour_moveon
/// @param  colour_press
function ts_link() {

	/*
	    url_or_script - url or script index to open/execute
	    colour_moveon - colour when mouse move on link
	    colour_press - colour when mouse pressed
	*/


	var str = "<<tag#"+string(ts.link)+"|";

	if argument_count>=1
	    str+=string(argument[0])+"|"
	else
	    str+="|"
    
	if argument_count>=2
	    str+=string(argument[1])+"|"
	else
	    str+="-1|"

	if argument_count>=3
	    str+=string(argument[2])+"|"
	else
	    str+="-1|"
    
	str+=">>"

	return str;



}
