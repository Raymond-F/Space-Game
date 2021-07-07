/// @description  ts_argument(str, ind[, sep])
/// @param str
/// @param  ind[
/// @param  sep]
function ts_argument() {

	var str="", nsep="", nseplen=1;

	if argument_count>=3
	{
	    nsep=argument[2]
	    nseplen=string_length(nsep)
	}

	for(var i=argument[1]; i<=string_length(argument[0]); i++)
	{
	    var symb=string_char_at(argument[0], i);
	    if symb="|"
	//    or (nsep!='' and string_copy(argument[0], i, nseplen)=nsep)
	    {
	        var arg=global.ts_varmap[? str];
	        if arg!=undefined 
	            return arg;
	        else
	            return str;
	    }
	    else 
	    {
	        str+=symb
	        if str=nsep
	            return nsep
	    }
	}

	var arg=global.ts_varmap[? str];
	if arg!=undefined 
	    return arg;
	else
	    return str;



}
