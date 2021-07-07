/// @description  text_format_destroy(text_id)
/// @param text_id
function text_format_destroy(argument0) {

	var l=argument0;
	ds_queue_destroy(l[| 2])
	ds_list_destroy(l)




}
