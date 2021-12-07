/// @description  text_render(text_id, x, y, halign, valign)
/// @param text_id
/// @param  x
/// @param  y
/// @param  halign
/// @param  valign
function text_render(argument0, argument1, argument2, argument3, argument4) {

	var l=argument0, xx=argument1, yy=argument2, halign=argument3, valign=argument4;

	var surf=text_get_surface(l);

	var X=0, Y=0;

	switch halign
	{
	    case fa_right: X=1; break
	    case fa_center: X=0.5; break
	}

	switch valign
	{
	    case fa_bottom: Y=1; break
	    case fa_center: Y=0.5; break
	}

	draw_surface(surf, xx-surface_get_width(surf)*X+5*(X*2-1), yy-surface_get_height(surf)*Y+5*(Y*2-1))




}
