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
		case "supplies" : global.supplies += amount; break;
		case "fuel" : global.fuel += amount; break;
		default : break;
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

//SHOP RELATED CODE
//rarity macros
#macro RARITY_UNAVAILABLE 0 //this is used for modules that might only be available through certain things like quests
#macro RARITY_UBIQ 1 //found everywhere. Every store has one of these if they sell this type of item. Found on things like supplies and fuel.
#macro RARITY_COMMON 2 //found commonly. The bulk of randomly rolled items will be this
#macro RARITY_UNCOMMON 3 //found uncommonly. High end items or basics of large modules
#macro RARITY_SCARCE 4 //found rarely. High end large modules
#macro RARITY_RARE 5 //found incredibly rarely. Cutting edge tech and capital-class module.
#macro RARITY_RESTRICTED 6 //found only in empire-approved shops. Only rolls within those shops.
//module macros
#macro MODULETYPE_DRIVE 0
#macro MODULETYPE_SHIELD 1

//module stats are a way to modularly get info out of the object
function modulestats_drive(_maneuvering, _impulse, _fuel_efficiency) {
	// maneuvering is a measure of how good the ship is at evasion in combat. It is added to pilot maneuvering.
	maneuvering = _maneuvering;
	// impulse is how many tiles an engine allows a ship to move on the local map. Larger ships have an inherent impulse penalty
	impulse = _impulse;
	// fuel efficiency is how much fuel a drive needs compared to normal. Higher means less fuel per jump, e.g. 2 uses half as much fuel as 1 
	fuel_efficiency = _fuel_efficiency;
	
	static info_strings = function() {
		return [
			"Maneuvering: " + string(maneuvering),
			"Impulse: " + string(impulse),
			"Fuel Efficiency: " + string(fuel_efficiency)
		]
	}
}

function module(_module_id, _name, _type, _size, _stats, _value, _rarity) {
	module_id = _module_id;
	name = _name;
	type = _type;
	size = _size;
	stats = _stats;
	value = _value;
	rarity = _rarity;
}

//roster for ship parts
function initialize_itemlist_modules() {
	var ilm = ds_map_create();
	
	ds_map_add_unique(ilm, 0, module(0, "Kepler D1", MODULETYPE_DRIVE, 1, modulestats_drive(25, 3, 1), 1000, RARITY_UBIQ));
	ds_map_add_unique(ilm, 1, module(1, "Mercanto Peddler", MODULETYPE_DRIVE, 1, modulestats_drive(10, 4, 1.5), 2200, RARITY_COMMON));
	ds_map_add_unique(ilm, 2, module(2, "K&H Hummingbird", MODULETYPE_DRIVE, 1, modulestats_drive(35, 5, 0.4), 6000, RARITY_SCARCE));
	
	ds_map_add_unique(ilm, 3, module(3, "Kepler D2", MODULETYPE_DRIVE, 2, modulestats_drive(32, 3, 1), 4500, RARITY_UBIQ));
	ds_map_add_unique(ilm, 4, module(4, "Heracles Harpy", MODULETYPE_DRIVE, 2, modulestats_drive(40, 2, 0.8), 11000, RARITY_COMMON));
	ds_map_add_unique(ilm, 5, module(5, "KIFEM Basic", MODULETYPE_DRIVE, 2, modulestats_drive(35, 3, 1.1), 9500, RARITY_COMMON));
	
	ds_map_add_unique(ilm, 6, module(6, "Mercanto Caraveener", MODULETYPE_DRIVE, 3, modulestats_drive(20, 5, 1.4), 15000, RARITY_COMMON));
	ds_map_add_unique(ilm, 7, module(7, "Heracles Gorgon", MODULETYPE_DRIVE, 3, modulestats_drive(47, 3, 0.7), 21750, RARITY_UNCOMMON));
	ds_map_add_unique(ilm, 8, module(8, "Sagittarius Alphajet", MODULETYPE_DRIVE, 3, modulestats_drive(40, 4, 1.1), 19500, RARITY_UNCOMMON));
	ds_map_add_unique(ilm, 9, module(9, "K&H Bluejay", MODULETYPE_DRIVE, 3, modulestats_drive(55, 5, 0.35), 32500, RARITY_SCARCE));

	ds_map_add_unique(ilm, 10, module(10, "Kepler D3", MODULETYPE_DRIVE, 4, modulestats_drive(45, 4, 0.9), 25000, RARITY_COMMON));
	ds_map_add_unique(ilm, 11, module(11, "K&H Falcon", MODULETYPE_DRIVE, 4, modulestats_drive(62, 5, 0.35), 60000, RARITY_RARE));
	ds_map_add_unique(ilm, 12, module(12, "KIFEM Advanced", MODULETYPE_DRIVE, 4, modulestats_drive(50, 4, 1.0), 35200, RARITY_COMMON));
	ds_map_add_unique(ilm, 13, module(13, "Mercanto Trader", MODULETYPE_DRIVE, 4, modulestats_drive(30, 6, 1.4), 29550, RARITY_UNCOMMON));

	ds_map_add_unique(ilm, 14, module(14, "Kepler D4", MODULETYPE_DRIVE, 5, modulestats_drive(50, 5, 0.85), 48500, RARITY_UNCOMMON));
	ds_map_add_unique(ilm, 15, module(15, "Mercanto Mogul", MODULETYPE_DRIVE, 5, modulestats_drive(37, 7, 1.35), 56250, RARITY_SCARCE));
	ds_map_add_unique(ilm, 16, module(16, "Heracles Hydra", MODULETYPE_DRIVE, 5, modulestats_drive(60, 4, 0.65), 75750, RARITY_SCARCE));
	ds_map_add_unique(ilm, 17, module(17, "Sagittarius Betajet", MODULETYPE_DRIVE, 5, modulestats_drive(54, 6, 1.0), 63000, RARITY_SCARCE));
	
	ds_map_add_unique(ilm, 18, module(18, "Heracles Titan", MODULETYPE_DRIVE, 6, modulestats_drive(70, 5, 0.6), 140000, RARITY_RARE));
	ds_map_add_unique(ilm, 19, module(19, "Sagittarius Gammajet", MODULETYPE_DRIVE, 6, modulestats_drive(62, 7, 1.0), 121500, RARITY_RARE));
	ds_map_add_unique(ilm, 20, module(20, "KIFEM Special", MODULETYPE_DRIVE, 6, modulestats_drive(60, 6, 0.9), 96000, RARITY_SCARCE));
	ds_map_add_unique(ilm, 21, module(21, "K&H Silverhawk", MODULETYPE_DRIVE, 6, modulestats_drive(77, 7, 0.3), 210900, RARITY_RARE));
	
	return ilm;
}