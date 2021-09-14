/// @description Insert description here
// You can write your code in this editor
if(PRESSED(ord("1"))){
	dsys_initialize_window("test0.txt");
} else if(PRESSED(ord("2"))){
	dsys_initialize_window("test1.txt");
} else if(PRESSED(ord("3"))){
	dsys_initialize_window("test2.txt");
} else if(PRESSED(vk_f1)){
	var input = get_string("DIALOGUE DEBUGGER: Enter the filename, including .txt, of the dialogue file you want to debug.", "");
	dsys_initialize_window(input);
} else if(PRESSED(vk_f2)){
	var input = get_string("FLAG SETTER: Enter the name of a flag to set the value of, a space, and then the value to set it to.", "");
	var tokens = string_tokenize(input);
	flag_set(tokens[0], int64(tokens[1]));
} else if(PRESSED(vk_f3)){
	var input = get_string("FLAG CHECKER: Enter the name of a flag and the value of that flag will be printed to the debug window.", "");
	show_debug_message("Value of flag '" + input + "': " + string(flag_get(input)));
} else if(PRESSED(vk_f9)){
	if(!instance_exists(o_combat_manager)) {
		instance_create(0,0, o_combat_manager);
		close_inventory();
	}
} else if(PRESSED(ord("I"))) {
	if(!instance_exists(o_inventory_pane) && !instance_exists(o_combat_manager) && !instance_exists(o_dialogue_manager)) {
		instance_create(GUIW/2 - sprite_get_width(s_inventory_pane)/2, GUIH/2 - sprite_get_height(s_inventory_pane)/2, o_inventory_pane);
	}
}