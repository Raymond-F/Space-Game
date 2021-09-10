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
#macro MODULETYPE_WEPSYS 2
#macro MODULETYPE_OTHER 3
//shipsize macros
#macro SHIPSIZE_SKIFF 1
#macro SHIPSIZE_CORVETTE 2
#macro SHIPSIZE_FRIGATE 3
#macro SHIPSIZE_CRUISER 4
#macro SHIPSIZE_BATTLECRUISER 5
#macro SHIPSIZE_BATTLESHIP 6

//module stats are a way to modularly get info out of the object
function modulestats_drive(_maneuvering, _impulse, _fuel_efficiency) constructor {
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
	
	static get_type = function() {
		return "drive";
	}
}

function modulestats_shield(_capacity, _recharge, _stability) constructor {
	// capacity is the raw shield pool a shield module provides at max. This is also what you start at.
	capacity = _capacity;
	// recharge is the amount of hitpoints your shield recharges per second at base.
	recharge = _recharge;
	// stability is "shield armor" aka the amount that incoming shield damage is reduced by.
	stability = _stability;
	
	static info_strings = function() {
		return [
			"Capacity: " + string(capacity),
			"Recharge: " + string(recharge),
			"Stability: " + string(stability)
		]
	}
	
	static get_type = function() {
		return "shield";
	}
}

function modulestats_wepsys(_processing, _speed_mod, _accuracy) constructor {
	//processing is how much weaponry the system can support at any one time. Any weapons not being supported will quickly uncharge.
	processing = _processing;
	//speed mod is a modifier to the default charging speed of a weapon. Higher is better. A weapon with a 1.1 modifier would charge 10% faster, while 0.9 would charge at 90% speed.
	speed_mod = _speed_mod;
	//accuracy is added to base pilot stats and weapon accuracy to determine how much dodge chance is mitigated.
	accuracy = _accuracy;
	
	static info_strings = function() {
		return [
			"Processing: " + string(processing),
			"Speed Mod: " + string(speed_mod),
			"Accuracy: " + string(accuracy)
		]
	}
	
	static get_type = function() {
		return "wepsys";
	}
}

function modulestats_cargo(_space) constructor {
	space = _space;
	
	static get_type = function() {
		return "cargo";
	}
}

function module(_module_id, _name, _type, _class, _stats, _value, _rarity) constructor {
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
	
	//DRIVES (index 0 to 99)
	
	ds_map_add_unique(ilm, 0, new module(0, "Kepler D1", MODULETYPE_DRIVE, 1, new modulestats_drive(25, 3, 1), 1000, RARITY_UBIQ));
	ds_map_add_unique(ilm, 1, new module(1, "Mercanto Peddler", MODULETYPE_DRIVE, 1, new modulestats_drive(10, 4, 1.5), 2200, RARITY_COMMON));
	ds_map_add_unique(ilm, 2, new module(2, "K&H Hummingbird", MODULETYPE_DRIVE, 1, new modulestats_drive(35, 5, 0.4), 6000, RARITY_SCARCE));
	
	ds_map_add_unique(ilm, 3, new module(3, "Kepler D2", MODULETYPE_DRIVE, 2, new modulestats_drive(32, 3, 1), 4500, RARITY_UBIQ));
	ds_map_add_unique(ilm, 4, new module(4, "Heracles Harpy", MODULETYPE_DRIVE, 2, new modulestats_drive(40, 2, 0.8), 11000, RARITY_COMMON));
	ds_map_add_unique(ilm, 5, new module(5, "KIFEM Basic", MODULETYPE_DRIVE, 2, new modulestats_drive(35, 3, 1.1), 9500, RARITY_COMMON));
	
	ds_map_add_unique(ilm, 6, new module(6, "Mercanto Caraveener", MODULETYPE_DRIVE, 3, new modulestats_drive(20, 5, 1.4), 15000, RARITY_COMMON));
	ds_map_add_unique(ilm, 7, new module(7, "Heracles Gorgon", MODULETYPE_DRIVE, 3, new modulestats_drive(47, 3, 0.7), 21750, RARITY_UNCOMMON));
	ds_map_add_unique(ilm, 8, new module(8, "Sagittarius Alphajet", MODULETYPE_DRIVE, 3, new modulestats_drive(40, 4, 1.1), 19500, RARITY_UNCOMMON));
	ds_map_add_unique(ilm, 9, new module(9, "K&H Bluejay", MODULETYPE_DRIVE, 3, new modulestats_drive(55, 5, 0.35), 32500, RARITY_SCARCE));

	ds_map_add_unique(ilm, 10, new module(10, "Kepler D3", MODULETYPE_DRIVE, 4, new modulestats_drive(45, 4, 0.9), 25000, RARITY_COMMON));
	ds_map_add_unique(ilm, 11, new module(11, "K&H Falcon", MODULETYPE_DRIVE, 4, new modulestats_drive(62, 5, 0.35), 60000, RARITY_RARE));
	ds_map_add_unique(ilm, 12, new module(12, "KIFEM Advanced", MODULETYPE_DRIVE, 4, new modulestats_drive(50, 4, 1.0), 35200, RARITY_COMMON));
	ds_map_add_unique(ilm, 13, new module(13, "Mercanto Trader", MODULETYPE_DRIVE, 4, new modulestats_drive(30, 6, 1.4), 29550, RARITY_UNCOMMON));

	ds_map_add_unique(ilm, 14, new module(14, "Kepler D4", MODULETYPE_DRIVE, 5, new modulestats_drive(50, 5, 0.85), 48500, RARITY_UNCOMMON));
	ds_map_add_unique(ilm, 15, new module(15, "Mercanto Mogul", MODULETYPE_DRIVE, 5, new modulestats_drive(37, 7, 1.35), 56250, RARITY_SCARCE));
	ds_map_add_unique(ilm, 16, new module(16, "Heracles Hydra", MODULETYPE_DRIVE, 5, new modulestats_drive(60, 4, 0.65), 75750, RARITY_SCARCE));
	ds_map_add_unique(ilm, 17, new module(17, "Sagittarius Betajet", MODULETYPE_DRIVE, 5, new modulestats_drive(54, 6, 1.0), 63000, RARITY_SCARCE));
	
	ds_map_add_unique(ilm, 18, new module(18, "Heracles Titan", MODULETYPE_DRIVE, 6, new modulestats_drive(70, 5, 0.6), 140000, RARITY_RARE));
	ds_map_add_unique(ilm, 19, new module(19, "Sagittarius Gammajet", MODULETYPE_DRIVE, 6, new modulestats_drive(62, 7, 1.0), 121500, RARITY_RARE));
	ds_map_add_unique(ilm, 20, new module(20, "KIFEM Special", MODULETYPE_DRIVE, 6, new modulestats_drive(60, 6, 0.9), 96000, RARITY_SCARCE));
	ds_map_add_unique(ilm, 21, new module(21, "K&H Silverhawk", MODULETYPE_DRIVE, 6, new modulestats_drive(77, 7, 0.3), 210900, RARITY_RARE));
	
	//SHIELDS (index 100 to 199)
	ds_map_add_unique(ilm, 100, new module(100, "Kepler SM-A", MODULETYPE_SHIELD, 1, new modulestats_shield(1200, 18, 0), 2250, RARITY_UBIQ));
	
	ds_map_add_unique(ilm, 103, new module(103, "Kepler SM-B", MODULETYPE_SHIELD, 2, new modulestats_shield(2000, 26, 0), 5700, RARITY_UBIQ));
	
	ds_map_add_unique(ilm, 106, new module(106, "Kepler SM-C", MODULETYPE_SHIELD, 3, new modulestats_shield(3600, 40, 0), 12000, RARITY_COMMON));
	ds_map_add_unique(ilm, 107, new module(107, "Heracles Pavise", MODULETYPE_SHIELD, 3, new modulestats_shield(3250, 50, 5), 17500, RARITY_UNCOMMON));
	
	ds_map_add_unique(ilm, 110, new module(110, "Kepler SM-D", MODULETYPE_SHIELD, 4, new modulestats_shield(5500, 70, 0), 21500, RARITY_COMMON));
	
	ds_map_add_unique(ilm, 113, new module(113, "Kepler SM-XL", MODULETYPE_SHIELD, 5, new modulestats_shield(9050, 110, 0), 38700, RARITY_UNCOMMON));
	
	//WEAPON SYSTEMS (index 200 to 299)
	
	ds_map_add_unique(ilm, 200, new module(200, "Heracles Falx", MODULETYPE_WEPSYS, 1, new modulestats_wepsys(8, 1, 10), 2500, RARITY_UBIQ));
	ds_map_add_unique(ilm, 201, new module(201, "MBT Spitfire", MODULETYPE_WEPSYS, 1, new modulestats_wepsys(4, 2, 0), 3700, RARITY_RARE));
	
	ds_map_add_unique(ilm, 202, new module(202, "KIFEM BT-3", MODULETYPE_WEPSYS, 2, new modulestats_wepsys(13, 0.9, 5), 7000, RARITY_COMMON));
	ds_map_add_unique(ilm, 203, new module(203, "Heracles Kopis", MODULETYPE_WEPSYS, 2, new modulestats_wepsys(8, 1.2, 15), 9250, RARITY_COMMON));
	
	ds_map_add_unique(ilm, 204, new module(204, "Sagittarius Sapphire", MODULETYPE_WEPSYS, 3, new modulestats_wepsys(15, 1, 13), 14000, RARITY_UNCOMMON));
	ds_map_add_unique(ilm, 205, new module(205, "Heracles Akontia", MODULETYPE_WEPSYS, 3, new modulestats_wepsys(12, 1.25, 21), 23500, RARITY_UNCOMMON));
	ds_map_add_unique(ilm, 206, new module(206, "KIFEM BT-5", MODULETYPE_WEPSYS, 3, new modulestats_wepsys(16, 0.9, 8), 12400, RARITY_COMMON));

	ds_map_add_unique(ilm, 207, new module(207, "Heracles Xiphos", MODULETYPE_WEPSYS, 4, new modulestats_wepsys(20, 1.0, 18), 35250, RARITY_UNCOMMON));
	ds_map_add_unique(ilm, 208, new module(208, "Heracles Doru", MODULETYPE_WEPSYS, 4, new modulestats_wepsys(14, 1.5, 25), 47000, RARITY_RARE));
	ds_map_add_unique(ilm, 209, new module(209, "KIFEM BT-7", MODULETYPE_WEPSYS, 4, new modulestats_wepsys(19, 0.9, 10), 22000, RARITY_COMMON));
	ds_map_add_unique(ilm, 210, new module(210, "MBT Slugger", MODULETYPE_WEPSYS, 4, new modulestats_wepsys(25, 0.5, 12), 40125, RARITY_RARE));
	
	ds_map_add_unique(ilm, 211, new module(211, "Heracles Khopesh", MODULETYPE_WEPSYS, 5, new modulestats_wepsys(18, 1.3, 20), 60000, RARITY_SCARCE));
	ds_map_add_unique(ilm, 212, new module(212, "Saggitarius Amethyst", MODULETYPE_WEPSYS, 5, new modulestats_wepsys(22, 1.1, 15), 52600, RARITY_SCARCE));
	ds_map_add_unique(ilm, 213, new module(213, "KIFEM BT-9", MODULETYPE_WEPSYS, 5, new modulestats_wepsys(23, 0.9, 12), 39250, RARITY_UNCOMMON));
	
	ds_map_add_unique(ilm, 214, new module(214, "Heracles Ballista", MODULETYPE_WEPSYS, 6, new modulestats_wepsys(25, 1.2, 25), 115000, RARITY_RARE));
	ds_map_add_unique(ilm, 215, new module(214, "KIFEM BT-10X", MODULETYPE_WEPSYS, 6, new modulestats_wepsys(26, 1.0, 15), 75000, RARITY_SCARCE));
	ds_map_add_unique(ilm, 216, new module(214, "MBT Hypershot", MODULETYPE_WEPSYS, 6, new modulestats_wepsys(10, 3, -10), 120550, RARITY_RARE));
	
	//OTHER SYSTEMS (index 500 to 999)
	ds_map_add_unique(ilm, 500, new module(500, "Cargo Pod", MODULETYPE_OTHER, 1, new modulestats_cargo(5), 500, RARITY_UBIQ));
	ds_map_add_unique(ilm, 501, new module(501, "Large Cargo Pod", MODULETYPE_OTHER, 2, new modulestats_cargo(10), 1000, RARITY_UBIQ));
	ds_map_add_unique(ilm, 502, new module(502, "Small Cargo Bay", MODULETYPE_OTHER, 3, new modulestats_cargo(20), 2000, RARITY_UBIQ));
	ds_map_add_unique(ilm, 503, new module(503, "Cargo Bay", MODULETYPE_OTHER, 4, new modulestats_cargo(40), 4000, RARITY_COMMON));
	ds_map_add_unique(ilm, 504, new module(504, "Large Cargo Bay", MODULETYPE_OTHER, 5, new modulestats_cargo(75), 8000, RARITY_COMMON));
	ds_map_add_unique(ilm, 505, new module(505, "Vast Cargo Bay", MODULETYPE_OTHER, 5, new modulestats_cargo(150), 15000, RARITY_UNCOMMON));
	
	return ilm;
}

//Weapons

function weaponstats(_damage, _charge_time, _processing_cost, _type, _notes) constructor {
	// How much damage a weapon does each time it's fired, notated as something like "40" or "5x10"
	damage = _damage;
	// How long a weapon takes to charge in seconds, e.g. "12"
	charge_time = _charge_time;
	// How many processing slots a weapon requires. Larger weapons require more slots.
	processing_cost = _processing_cost;
	// Type of weapon
	type = _type;
	// Notes shown in a weapon's info box, e.g. "EMP" or "Bonus damage to shields"
	notes = _notes;
}

function weapon(_weapon_id, _name, _index, _stats, _value, _rarity) constructor {
	weapon_id = _weapon_id;
	name = _name;
	index = _index;
	stats = _stats;
	value = _value;
	rarity = _rarity;
}

function initialize_itemlist_weapons() {
	
	var ilw = ds_map_create();
	
	// basic projectile weapons (index 0 to 99)
	ds_map_add_unique(ilw, 0, new weapon(0, "Cantor Dirk", o_weapon_cantor_dirk, new weaponstats("8x10", 8, 1, weapon_type.projectile, ""), 800, RARITY_UBIQ));
	
	return ilw;
}

//Stuff about the actual ships

function ship_statistics(_hull, _armor, _impulse_penalty, _evasion_penalty) constructor {
	//The hitpoints of the ship. When you run out of this you are dead.
	hull = _hull;
	//The armor of the ship. This shaves damage off of each hit.
	armor = _armor;
	//How much the ship negates impulse of the drive. Larger ships tend to negate more.
	impulse_penalty = _impulse_penalty;
	//How much the ship reduces the evasion of the mounted drive. Larger ships tend to have a higher penalty.
	evasion_penalty = _evasion_penalty;
}

function shipinfo(_ship_id, _name, _sprite, _class, _mod_slots, _hardpoints, _engines, _statistics, _built_in_mods, _value, _rarity) constructor {
	ship_id = _ship_id;
	name = _name;
	sprite = _sprite
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
	hardpoints = _hardpoints; // Hardpoints are relative to the center of the ship model, e.g. [50, -50] will be in the top right and [-20, 70] will be on the bottom left
	engines = _engines;
	statistics = _statistics;
	built_in_mods = _built_in_mods;
	value = _value;
	rarity = _rarity;
}

function initialize_shipinfo() {
	var si = ds_map_create();
	
	//SKIFFS (index 0 to 99)
	
	ds_map_add_unique(si, 0, new shipinfo(0, "Kepler Proteus", s_ship_kepler_proteus, SHIPSIZE_SKIFF, [4, 1], [[40, -45], [-40, -20]], [[-35, 75], [35, 75]], new ship_statistics(2500, 3, 0, 0), [], 5000, RARITY_UBIQ));
	ds_map_add_unique(si, 1, new shipinfo(1, "Mercanto Packmule", s_ship_kepler_proteus, SHIPSIZE_SKIFF, [3, 1], [[0,0]], [[0, 100]],new ship_statistics(1350, 0, 0, 10), [502], 6750, RARITY_COMMON));//built in class 3 cargo
	
	//CORVETTES (index 100 to 199)
	
	//FRIGATES (index 200 to 299)
	
	//CRUISERS (index 300 to 399)
	ds_map_add_unique(si, 300, new shipinfo(0, "Kepler Oberon", s_ship_kepler_proteus, SHIPSIZE_CRUISER, [2, 2, 3, 2], [[-30, -50], [30, -50], [-40, -20], [40, -20], [0, -10], [0, 20]], [[-60, 150], [60, 150]], new ship_statistics(11000, 10, 2, 20), [], 64500, RARITY_UNCOMMON));
	
	//BATTLECRUISERS (index 400 to 499)
	
	//BATTLESHIPS (index 500 to 599)
	
	return si
}

function initialize_default_player_ship() {
	var sh = new ship(global.shiplist[? 0]);
	sh.class1 = [0, 100, 200, 500];
	sh.class2 = [501];
	sh.hardpoint_objects = [0, 0];
	return sh;
}