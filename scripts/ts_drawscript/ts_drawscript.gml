/// @description  ts_drawscript([script, index])
/// @param [script
/// @param  index]
function ts_drawscript() {

	// it works only with ts_effects(true)


	var str = "<<tag#"+string(ts.script)+"|", scr=-1;

	if argument_count>=2 and argument[1]+15>=0
	    str+=string(argument[1]+15)+"|"
	else
	    str+="15|"

	if argument_count>=1
	    scr=argument[0]

	if is_string(scr)
	    scr=asset_get_index(scr)

	str+=string(scr)+"|"
    
	str+=">>"

	return str;




}
