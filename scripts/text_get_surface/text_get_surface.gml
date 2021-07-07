/// @description  text_get_surface(text_id)
/// @param text_id
function text_get_surface(argument0) {

	var surf=argument0[| 1];

	if argument0[| 2] 
	{
	    surf=text_refresh(argument0, argument0[| 3], argument0[| 4])
	    argument0[| 2]=0
	}
	if !surface_exists(surf)
	{
	    text_refresh(argument0, argument0[| 3], argument0[| 4])
	    surf=text_get_surface(argument0)
	}

	return surf;



}
