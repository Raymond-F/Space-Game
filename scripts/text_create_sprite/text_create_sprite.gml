/// @description  text_create_sprite(text_id, smooth, xorig, yorig)
/// @param text_id
/// @param  smooth
/// @param  xorig
/// @param  yorig
function text_create_sprite(argument0, argument1, argument2, argument3) {
	return sprite_create_from_surface(text_get_surface(argument0), 0, 0, text_width(argument0), text_height(argument0), 0, argument1, argument2, argument3)



}
