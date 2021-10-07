/// @description Insert description here
// You can write your code in this editor
if(PRESSED(ord("1"))){
	dsys_initialize_window("test0.txt");
} else if(PRESSED(ord("2"))){
	dsys_initialize_window("test1.txt");
} else if(PRESSED(ord("3"))){
	dsys_initialize_window("test2.txt");
} else if (PRESSED(ord("4"))){
	dsys_initialize_window("dlg_test_battlestart.txt")
} else if (PRESSED(192)) { // Tilde (~) key
	db_terminal();
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
	combat_setup();
} else if(PRESSED(ord("I"))) {
	if(!instance_exists(o_inventory_pane) && !instance_exists(o_combat_manager) && !instance_exists(o_dialogue_manager)) {
		instance_create(GUIW/2 - sprite_get_width(s_inventory_pane)/2, GUIH/2 - sprite_get_height(s_inventory_pane)/2, o_inventory_pane);
	} else {
		close_inventory();
	}
} else if(PRESSED(ord("M"))) {
	close_inventory();
	if (!instance_exists(o_gui_sectormap) && global.context == context.zone_map) {
		with(o_controller_zonemap) {
			location_prompt_button.y = GUIH;
		}
		instance_create(0, 0, o_gui_sectormap);
		zonemap_deactivate_objects();
		global.previous_context = global.context;
		global.context = context.sector_map;
	} else if (global.context == context.sector_map) {
		with (o_gui_sectormap) { instance_destroy(); }
		zonemap_activate_objects();
		global.previous_context = global.context;
		global.context = context.zone_map;
	}
} else if (PRESSED(vk_pageup)) {
	global.current_turn += 100;
}

if (PRESSED(vk_backspace)) {
	global.debug = !global.debug;
}