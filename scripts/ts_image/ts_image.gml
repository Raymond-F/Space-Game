/// @description  ts_image(sprite_index, [w, h, type, [x, y]])
/// @param sprite_index
/// @param  [w
/// @param  h
/// @param  type
/// @param  [x
/// @param  y]]
function ts_image() {

	/*
	    sprite_index - index of sprite that you want to add
	    w, h - size to scaling image, use ts.standart or skip 
	        to default value(size of one symbol),
	        or use ts.original to use original size of image
	    type - type of scaling:
	        ts.img_scale - image scaling to current size and saving proportion
	        ts.img_fullscale - image scaling and dont saving proportion
	        ts.img_partscale - image scaling, save proportions and unnecessary parts are cut
	        ts.img_part - drawing part of image without scaling, use arguments "x" and "y" to set what part will be draw, or skip to default value(0)
	*/

	var str = "<<tag#"+string(ts.image)+"|"+string(argument[0])+"|", type=ts.img_scale;

	if argument_count>=4 // type
	    type=argument[3]
    
	str+=string(type)+"|"

	if argument_count>=2 // w
	    str+=string(argument[1])+"|"
	else
	    str+=string(ts.standart)+"|"
    
	if argument_count>=3 // h
	    str+=string(argument[2])+"|"
	else
	    str+=string(ts.standart)+"|"
    
	if argument_count>=5 // x
	    str+=string(argument[4])+"|"
	else
	    str+="0|"
    
	if argument_count>=6 // y
	    str+=string(argument[5])+"|"
	else
	    str+="0|"
    
	str+=">>"

	return str;



}
