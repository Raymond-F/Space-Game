/// @description Insert description here
// You can write your code in this editor
if(active && MPRESSED(mb_left)){
	if(gui_mouse_is_in_area(x, y, width, height)){
		if (link_type == option_link_type.dialogue) {
			if(link == ""){
				with(parent){
					instance_destroy();
				}
			}
			else {
				dsys_set_node(parent, link, id);
			}
		} else if (link_type == option_link_type.battle) {
			global.battle_file = link;
			combat_setup();
			with (parent) {
				instance_destroy();
			}
		}
	}
}