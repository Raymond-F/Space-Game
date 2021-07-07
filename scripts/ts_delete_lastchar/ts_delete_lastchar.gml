/// @description  ts_delete_lastchar(string)
/// @param string
function ts_delete_lastchar(argument0) {

	var text=argument0, textlen=string_length(text), flist=global.ts_flist;


	// delete default tags

	if string_copy(text, textlen-1, 2)=">>"
	{
	    for(var i=textlen-1-6; i>=1; i--)
	    {
	        var ctag=-1;
	        if string_copy(text, i, 2)=">>" break
	        if string_copy(text, i, 6)="<<tag#"
	            ctag=real(string_copy(text, i+6, 1));
            
	        if string_copy(text, i, 7)="<<line#" or ctag=ts.image
	            return string_delete(text, i, textlen-i+1)
	        else if ctag!=-1
	        {
	            text=string_delete(text, i, textlen-i+1)
	            textlen=i
	        }
	    }
	}


	// delete keywords

	for(var z=0; z<ds_list_size(flist); z+=2)
	{
	    var cz=flist[| z], clen=string_length(cz), d=1;
	    if string_copy(text, textlen-clen+1, clen)=cz
	        return string_copy(text, 1, textlen-clen)
	}



	// delete usertags
	for(var i=0; i<ds_list_size(global.ts_usertags); i++)
	{
	    var ctag=global.ts_usertags[| i];
	    var start=ctag[| 0], en=ctag[| 2], startlen=string_length(start), enlen=string_length(en);
    
	    if string_copy(text, textlen-enlen+1, enlen)=enlen
	    for(var j=textlen-startlen-enlen+1; j>=1; j--)
	    {
	        if string_copy(text, j, 2)=">>" break
	        if string_copy(text, j, startlen)=start
	            return string_delete(text, j, textlen-j+1)
	    }
	}

	// delete symbol
	return string_copy(text, 1, textlen-1)



}
