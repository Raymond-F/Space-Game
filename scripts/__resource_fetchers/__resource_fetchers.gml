// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function initialize_sprite_map(){
	var sm = ds_map_create();
	ds_map_add(sm, "pix", s_icon_pix);
	ds_map_add(sm, "crew", s_icon_crew);
	ds_map_add(sm, "supplies", s_icon_supplies);
	ds_map_add(sm, "fuel", s_icon_fuel);
	return sm;
}

function fetch_sprite(str) {
	return global.sprite_map[?str];
}

function fetch_sprite_atex(str) {
	return ts_image(fetch_sprite(str), ICON_WIDTH, ICON_HEIGHT);
}

function query_resource(str) {
	switch (str) {
		case "pix" : return global.pix; break;
		case "crew" : return global.crew; break;
		case "supplies" : return global.supplies; break;
		case "fuel" : return global.fuel; break;
		default: return -1;
	}
}

function modify_resource(str, amount) {
	switch (str) {
		case "pix" : global.pix += amount; break;
		case "crew" : global.crew += amount; break;
		case "supplies" : global.supplies += amount; break;
		case "fuel" : global.fuel += amount; break;
		default : break;
	}
}

function flag_get(flag_name) {
	if(!ds_map_exists(global.flags, flag_name)){
		show_debug_message("WARNING: Attempted to access nonexistent flag: " + flag_name);
		return 0;
	}
	else {
		return ds_map_find_value(global.flags, flag_name);
	}
}

function flag_set(flag_name, new_value) {
	if(!ds_map_exists(global.flags, flag_name)){
		ds_map_add(global.flags, flag_name, new_value);
	}
	else {
		ds_map_replace(global.flags, flag_name, new_value);
	}
}

function flag_remove(flag_name) {
	if(ds_map_exists(global.flags, flag_name)){
		ds_map_delete(global.flags, flag_name);
	}
}