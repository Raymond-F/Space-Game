// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
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
//shipsize macros
#macro SHIPSIZE_SKIFF 1
#macro SHIPSIZE_CORVETTE 2
#macro SHIPSIZE_FRIGATE 3
#macro SHIPSIZE_CRUISER 4
#macro SHIPSIZE_BATTLECRUISER 5
#macro SHIPSIZE_BATTLESHIP 6

function ship(_ship_id, _name, _class, _mod_slots) {
	ship_id = _ship_id;
	name = _name;
	class = _class;
	switch(array_length(_mod_slots)){
		case 1: mod_slots = [_mod_slots[0], 0, 0, 0, 0, 0]; break;
		case 2: mod_slots = [_mod_slots[0], _mod_slots[1], 0, 0, 0, 0]; break;
		case 3: mod_slots = [_mod_slots[0], _mod_slots[1], _mod_slots[2], 0, 0, 0]; break;
		case 4: mod_slots = [_mod_slots[0], _mod_slots[1], _mod_slots[2], _mod_slots[3], 0, 0]; break;
		case 5: mod_slots = [_mod_slots[0], _mod_slots[1], _mod_slots[2], _mod_slots[3], _mod_slots[4], 0]; break;
		case 6: mod_slots = [_mod_slots[0], _mod_slots[1], _mod_slots[2], _mod_slots[3], _mod_slots[4], _mod_slots[5]]; break;
		default: mod_slots = [0, 0, 0, 0, 0, 0]; break;
	}
}

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

function module(_module_id, _name, _type, _class, _stats, _value, _rarity) {
	module_id = _module_id;
	name = _name;
	type = _type;
	class = _class;
	stats = _stats;
	value = _value;
	rarity = _rarity;
}

//roster for ship parts
function initialize_itemlist_modules() {
	var ilm = ds_map_create();
	
	ds_map_add_unique(ilm, 0, new module(0, "Kepler D1", MODULETYPE_DRIVE, 1, modulestats_drive(25, 3, 1), 1000, RARITY_UBIQ));
	ds_map_add_unique(ilm, 1, new module(1, "Mercanto Peddler", MODULETYPE_DRIVE, 1, modulestats_drive(10, 4, 1.5), 2200, RARITY_COMMON));
	ds_map_add_unique(ilm, 2, new module(2, "K&H Hummingbird", MODULETYPE_DRIVE, 1, modulestats_drive(35, 5, 0.4), 6000, RARITY_SCARCE));
	
	ds_map_add_unique(ilm, 3, new module(3, "Kepler D2", MODULETYPE_DRIVE, 2, modulestats_drive(32, 3, 1), 4500, RARITY_UBIQ));
	ds_map_add_unique(ilm, 4, new module(4, "Heracles Harpy", MODULETYPE_DRIVE, 2, modulestats_drive(40, 2, 0.8), 11000, RARITY_COMMON));
	ds_map_add_unique(ilm, 5, new module(5, "KIFEM Basic", MODULETYPE_DRIVE, 2, modulestats_drive(35, 3, 1.1), 9500, RARITY_COMMON));
	
	ds_map_add_unique(ilm, 6, new module(6, "Mercanto Caraveener", MODULETYPE_DRIVE, 3, modulestats_drive(20, 5, 1.4), 15000, RARITY_COMMON));
	ds_map_add_unique(ilm, 7, new module(7, "Heracles Gorgon", MODULETYPE_DRIVE, 3, modulestats_drive(47, 3, 0.7), 21750, RARITY_UNCOMMON));
	ds_map_add_unique(ilm, 8, new module(8, "Sagittarius Alphajet", MODULETYPE_DRIVE, 3, modulestats_drive(40, 4, 1.1), 19500, RARITY_UNCOMMON));
	ds_map_add_unique(ilm, 9, new module(9, "K&H Bluejay", MODULETYPE_DRIVE, 3, modulestats_drive(55, 5, 0.35), 32500, RARITY_SCARCE));

	ds_map_add_unique(ilm, 10, new module(10, "Kepler D3", MODULETYPE_DRIVE, 4, modulestats_drive(45, 4, 0.9), 25000, RARITY_COMMON));
	ds_map_add_unique(ilm, 11, new module(11, "K&H Falcon", MODULETYPE_DRIVE, 4, modulestats_drive(62, 5, 0.35), 60000, RARITY_RARE));
	ds_map_add_unique(ilm, 12, new module(12, "KIFEM Advanced", MODULETYPE_DRIVE, 4, modulestats_drive(50, 4, 1.0), 35200, RARITY_COMMON));
	ds_map_add_unique(ilm, 13, new module(13, "Mercanto Trader", MODULETYPE_DRIVE, 4, modulestats_drive(30, 6, 1.4), 29550, RARITY_UNCOMMON));

	ds_map_add_unique(ilm, 14, new module(14, "Kepler D4", MODULETYPE_DRIVE, 5, modulestats_drive(50, 5, 0.85), 48500, RARITY_UNCOMMON));
	ds_map_add_unique(ilm, 15, new module(15, "Mercanto Mogul", MODULETYPE_DRIVE, 5, modulestats_drive(37, 7, 1.35), 56250, RARITY_SCARCE));
	ds_map_add_unique(ilm, 16, new module(16, "Heracles Hydra", MODULETYPE_DRIVE, 5, modulestats_drive(60, 4, 0.65), 75750, RARITY_SCARCE));
	ds_map_add_unique(ilm, 17, new module(17, "Sagittarius Betajet", MODULETYPE_DRIVE, 5, modulestats_drive(54, 6, 1.0), 63000, RARITY_SCARCE));
	
	ds_map_add_unique(ilm, 18, new module(18, "Heracles Titan", MODULETYPE_DRIVE, 6, modulestats_drive(70, 5, 0.6), 140000, RARITY_RARE));
	ds_map_add_unique(ilm, 19, new module(19, "Sagittarius Gammajet", MODULETYPE_DRIVE, 6, modulestats_drive(62, 7, 1.0), 121500, RARITY_RARE));
	ds_map_add_unique(ilm, 20, new module(20, "KIFEM Special", MODULETYPE_DRIVE, 6, modulestats_drive(60, 6, 0.9), 96000, RARITY_SCARCE));
	ds_map_add_unique(ilm, 21, new module(21, "K&H Silverhawk", MODULETYPE_DRIVE, 6, modulestats_drive(77, 7, 0.3), 210900, RARITY_RARE));
	
	return ilm;
}