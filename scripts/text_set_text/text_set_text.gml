/// @description  text_set_text(text_id, newtext, font, maxw)
/// @param text_id
/// @param  newtext
/// @param  font
/// @param  maxw
function text_set_text(argument0, argument1, argument2, argument3) {

	// set new text and refresh

	argument0[| 0]=argument1
	argument0[| 2]=1
	argument0[| 3]=argument2
	argument0[| 4]=argument3



}
