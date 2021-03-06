// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
enum shop_type {
	general,
	weapon,
	module,
	ship
}

function shop(_type, _loc) constructor {
	type = _type;
	loc = _loc; // Location struct this is part of
	inventory = ds_list_create();
}

// Clears the inventory of a given shop, including all cleanup associated.
function shop_clear_inventory(_shop) {
	for (var i = 0; i < ds_list_size(_shop.inventory); i++) {
		var it = _shop.inventory[|i];
		if (_shop.type = shop_type.ship) {
			delete it.struct;
		}
	}
	ds_list_clear(_shop.inventory);
}

// Restock a given shop. This differs heavily based type of shop and the zone it's in.
//   - Low security reduces shop stock
//   - High settlement size increases shop stock
//   - High security and settlement size both increase average rarity
function shop_restock(_shop) {
	var rarity_table = [];
	var rarity_modifiers = [];
	var valid_tags = [];
	var loc = _shop.loc;
	var t = _shop.type;
	var total_stock;
	
	shop_clear_inventory(_shop);
	switch (t) {
		case shop_type.general: total_stock = irandom_range(20, 25); break;
		case shop_type.weapon: total_stock = irandom_range(4, 7); break;
		case shop_type.module: total_stock = irandom_range(3, 5); break;
		case shop_type.ship: total_stock = irandom_range(2, 3); break;
		default: total_stock = 10;
	}
	if (loc.size == location_size.medium) {
		total_stock = round(total_stock * random_range(1.6, 1.8));
	} else if (loc.size == location_size.large) {
		total_stock = round(total_stock * random_range(2.75, 3.5));
	}
	if (t == shop_type.general) {
		array_push(valid_tags, "basics");
		if (settlement_has_industry(loc, industry.mining)) {
			array_push(valid_tags, "ore");
		}
		if (settlement_has_industry(loc, industry.icecutting)) {
			array_push(valid_tags, "ice");
		}
		if (settlement_has_industry(loc, industry.refining)) {
			array_push(valid_tags, "refined");
		}
		if (settlement_has_industry(loc, industry.agriculture)) {
			array_push(valid_tags, "plants");
		}
		if (settlement_has_industry(loc, industry.hardware)) {
			array_push(valid_tags, "manufactured");
		}
		if (settlement_has_industry(loc, industry.luxury)) {
			array_push(valid_tags, "luxury");
		}
		if (settlement_has_industry(loc, industry.research)) {
			array_push(valid_tags, "drugs");
		}
	}
	switch (loc.size) {
		case location_size.small: rarity_table = [0.7, 0.2, 0.07, 0.03]; break;
		case location_size.medium: rarity_table = [0.6, 0.25, 0.11, 0.04]; break;
		case location_size.large: rarity_table = [0.55, 0.25, 0.15, 0.05]; break;
		default: rarity_table = [1, 0, 0, 0]; break;
	}
	switch (loc.zone_id.security) {
		case zone_security.high: rarity_modifiers = [1, 1.1, 1.2, 1.4]; break;
		case zone_security.moderate: rarity_modifiers = [1, 1, 1.1, 1.1]; break;
		case zone_security.sparse: rarity_modifiers = [1, 1, 0.9, 0.8]; break;
		case zone_security.little: rarity_modifiers = [1, 0.8, 0.7, 0.5]; break;
		case zone_security.lawless: rarity_modifiers = [1, 0.75, 0.5, 0.3]; break;
	}
	for (var i = 0; i < array_length(rarity_table); i++) {
		rarity_table[i] = rarity_table[i] * rarity_modifiers[i];
	}
	
	static has_valid_tag = function(it, tags) {
		for (var i = 0; i < array_length(tags); i++) {
			if (array_find(it.tags, tags[i]) >= 0) {
				return true;
			}
		}
		return false;
	}
	
	// Get the list of items, by rarity, and only getting items with matching tags
	var list;
	switch (t) {
		case shop_type.general: list = global.itemlist_cargo; break;
		case shop_type.weapon: list = global.itemlist_weapons; break;
		case shop_type.module: list = global.itemlist_modules; break;
		case shop_type.ship: list = global.shiplist; break;
	}
	var common = [], uncommon = [], scarce = [], rare = [];
	var ubiq_quantity = total_stock * random_range(0.4, 0.6);
	var key = ds_map_find_first(list);
	for (var i = 0; i < ds_map_size(list); i++) {
		if (is_undefined(key)) {
			break;
		}
		var it = list[? key];
		if (t != shop_type.general || has_valid_tag(it, valid_tags)) {
			switch (it.rarity) {
				case RARITY_UBIQ : inventory_add_item(_shop.inventory, it, round(ubiq_quantity * random_range(0.75, 1.2))); break;
				case RARITY_COMMON : array_push(common, it); break;
				case RARITY_UNCOMMON : array_push(uncommon, it); break;
				case RARITY_SCARCE : array_push(scarce, it); break;
				case RARITY_RARE : array_push(rare, it); break;
				default: break;
			}
		}
		key = ds_map_find_next(list, key);
	}
	
	if (array_length(common) == 0 && array_length(uncommon) == 0 && array_length(scarce) == 0 && array_length(rare) == 0) {
		return;
	}
	
	// At last, choose items randomly until we reach our decided inventory size.
	repeat (total_stock) {
		do {
			var r = choose_weighted(common, rarity_table[0], uncommon, rarity_table[1], scarce, rarity_table[2], rare, rarity_table[3]);
			var choice = array_choose(r);
		} until (choice != noone);
		inventory_add_item(_shop.inventory, choice, 1);
	}
}

// Calculate the value of a given item at a given shop.
//   - If a place can produce that item, the value is drastically reduced for selling and somewhat cheaper to buy
//   - If a place can consume that item, the value is increased
//   - Quantity in stock has no effect on price
//   - Prices are effected by the global buy and sell modifiers of a location, which fluctuate
function shop_calculate_item_value(sh, it) {
	var loc = sh.loc;
	var m = loc.global_buymod; // modifier
	if (variable_struct_exists(it, "tags")) {
		if (settlement_has_industry(loc, industry.mining) && it.has_tag("ore")) {
			m *= 0.8;
		}
		if (settlement_has_industry(loc, industry.refining) && it.has_tag("refined")) {
			m *= 0.85;
		}
		if (settlement_has_industry(loc, industry.icecutting) && it.has_tag("ice")) {
			m *= 0.6;
		}
		if (settlement_has_industry(loc, industry.agriculture) && it.has_tag("organic")) {
			m *= 0.85;
		}
		if (settlement_has_industry(loc, industry.hardware) && it.has_tag("manufactured")) {
			m *= 0.9;
		}
		if (settlement_has_industry(loc, industry.luxury) && it.has_tag("luxury")) {
			m *= 0.9;
		}
	}
	it.value = round(it.list[? it.list_id].value * m);
}

// Set player-side shop values. Trade goods have to use a different formula.
function shop_calculate_player_item_value(sh, it) {
	var loc = sh.loc;
	if (!variable_struct_exists(it, "tags")) {
		var m = loc.global_sellmod;
		it.value = round(it.list[? it.list_id].value * m);
		return;
	}
	if (!it.has_tag("trade")) {
		var m = loc.global_sellmod; // modifier
		if (settlement_has_industry(loc, industry.mining) && it.has_tag("ore")) {
			m *= 0.8;
		}
		if (settlement_has_industry(loc, industry.refining) && it.has_tag("refined")) {
			m *= 0.85;
		}
		if (settlement_has_industry(loc, industry.icecutting) && it.has_tag("ice")) {
			m *= 0.6;
		}
		if (settlement_has_industry(loc, industry.agriculture) && it.has_tag("organic")) {
			m *= 0.85;
		}
		if (settlement_has_industry(loc, industry.hardware) && it.has_tag("manufactured")) {
			m *= 0.9;
		}
		if (settlement_has_industry(loc, industry.luxury) && it.has_tag("luxury")) {
			m *= 0.9;
		}
	} else {
		var m = loc.global_buymod * 0.9; // modifier
		if (settlement_has_industry(loc, industry.mining) && it.has_tag("ore")) {
			m *= 0.2;
		}
		if (settlement_has_industry(loc, industry.refining) && it.has_tag("refined")) {
			m *= 0.2;
		}
		if (settlement_has_industry(loc, industry.icecutting) && it.has_tag("ice")) {
			m *= 0.1;
		}
		if (settlement_has_industry(loc, industry.agriculture) && it.has_tag("organic")) {
			m *= 0.3;
		}
		if (settlement_has_industry(loc, industry.hardware) && it.has_tag("manufactured")) {
			m *= 0.2;
		}
		if (settlement_has_industry(loc, industry.luxury) && it.has_tag("luxury")) {
			m *= 0.5;
		}
	}
	it.value = round(it.list[? it.list_id].value * m);
}