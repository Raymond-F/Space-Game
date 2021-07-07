/// @description  ts_shadow(bool, [pos_x, pos_y, colour, alpha])
/// @param bool
/// @param  [pos_x
/// @param  pos_y
/// @param  colour
/// @param  alpha]
function ts_shadow() {

	/*
	    bool - on/off
	    pos_x - x of shadow
	    pos_y - y of shadow
	    colour - colour of shadow, use ts.standart or -1 to set color as other text
	    alpha - alpha of shadow, use ts.standart or -1 to set alpha as other text
	*/


	var str = "<<tag#"+string(ts.shadow)+"|"+string(argument[0])+"|";

	if argument_count>=2
	    str+=string(argument[1])+"|"
	else
	    str+="1|"

	if argument_count>=3
	    str+=string(argument[2])+"|"
	else
	    str+="1|"
    
	if argument_count>=4
	    str+=string(argument[3])+"|"
	else
	    str+="0|"
    
	if argument_count>=5
	    str+=string(argument[4])+"|"
	else
	    str+="1|"
        
	str+=">>"

	return str;



}
