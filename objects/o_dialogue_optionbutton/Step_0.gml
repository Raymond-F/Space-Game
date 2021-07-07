/// @description Insert description here
// You can write your code in this editor
if(MPRESSED(mb_left)){
	if(gui_mouse_is_in_area(x, y, width, height)){
		if(link == ""){
			with(parent){
				instance_destroy();
			}
		}
		else {
			dsys_set_node(parent, link);
		}
	}
}