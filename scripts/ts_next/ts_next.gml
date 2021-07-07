/// @description  ts_next(str, ind[, sep])
/// @param str
/// @param  ind[
/// @param  sep]
function ts_next() {

	var nsep="", nseplen=1;

	if argument_count>=3
	{
	    nsep=argument[2]
	    nseplen=string_length(nsep)
	}

	for(var i=argument[1]; i<=string_length(argument[0]); i++)
	{
	    if string_char_at(argument[0], i)="|"
	        return i+1;
	    else 
	    if nsep!="" and string_copy(argument[0], i, nseplen)=nsep
	    {
	        return i+nseplen
	    }
	}

	return i;



}
