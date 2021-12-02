// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function initialize_sprite_map(){
	var sm = ds_map_create();
	ds_map_add(sm, "pix", s_icon_pix);
	ds_map_add(sm, "crew", s_icon_crew);
	ds_map_add(sm, "supplies", s_icon_supplies);
	ds_map_add(sm, "fuel", s_icon_fuel);
	ds_map_add(sm, "gunnery", s_icon_gunnery);
	ds_map_add(sm, "maneuvering", s_icon_maneuvering);
	ds_map_add(sm, "leadership", s_icon_leadership);
	ds_map_add(sm, "tech", s_icon_tech);
	ds_map_add(sm, "guts", s_icon_guts);
	ds_map_add(sm, "wits", s_icon_wits);
	ds_map_add(sm, "will", s_icon_will);
	ds_map_add(sm, "charm", s_icon_charm);
	return sm;
}

function fetch_sprite(str) {
	return global.sprite_map[?str];
}

function fetch_sprite_atex(str) {
	return ts_image(fetch_sprite(str), ICON_WIDTH, ICON_HEIGHT);
}

function query_attribute(str) {
	switch (str) {
		case "gunnery" : return global.gunnery; break;
		case "maneuvering" : return global.maneuvering; break;
		case "leadership" : return global.leadership; break;
		case "tech" : return global.tech; break;
		case "guts" : return global.guts; break;
		case "wits" : return global.wits; break;
		case "will" : return global.will; break;
		case "charm" : return global.charm; break;
		default: return 0;
	}
}

function skilltest_get_percentage(attribute, target) {
	if(target <= 0){
		return 1;
	}
	var player_att = query_attribute(attribute);
	var normalized_att = player_att/target;
	return logn(3, normalized_att+1);
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
		case "supplies" : if (amount > 0) {
				inventory_add_item(global.player_inventory, global.itemlist_cargo[? 0], amount);
			} else {
				inventory_remove_item(global.player_inventory, "supplies", -amount);
			} update_item_display(); break;
		case "fuel" : if (amount > 0) {
				inventory_add_item(global.player_inventory, global.itemlist_cargo[? 1], amount);
			} else {
				inventory_remove_item(global.player_inventory, "fuel", -amount);
			} update_item_display(); break;
		default : break;
	}
}

function str_to_faction(str) {
	switch (str) {
		case "kfed" : return factions.kfed; break;
		case "player" : return factions.player; break;
		case "rebel" : return factions.rebel; break;
		case "empire" : return factions.empire; break;
		case "pirate" : return factions.pirate; break;
		case "civilian" : return factions.civilian; break;
		default: return noone; break;
	}
}

function flag_get(flag_name) {
	if(!ds_map_exists(global.flags, flag_name)){
		show_debug_message("WARNING: Attempted to access nonexistent flag: " + flag_name + " [This can be ignored if this flag is local]");
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