/// @description Insert description here
// You can write your code in this editor
clear_objects = function() {
	with(o_modulecard) {
		instance_destroy();
	}
	with(o_modulesocket) {
		instance_destroy();
	}
	with(o_weaponcard) {
		instance_destroy();
	}
	with(o_weaponsocket) {
		instance_destroy();
	}
	for (var i = 0; i < ds_list_size(buttons); i++) {
		instance_destroy(buttons[|i]);
	}
	ds_list_clear(cards);
	ds_list_clear(sockets);
	ds_list_clear(buttons);
	scroll = 0;
}

create_modulemanager = function() {
	tab = open_tab.module;
	clear_objects();
	create_modulecards();
	create_modulesockets();
	create_buttons_modulemanager();
	top_text = "MANAGE MODULES";
	image_index = 0;
}

create_weaponmanager = function() {
	tab = open_tab.weapon;
	clear_objects();
	create_weaponcards();
	create_weaponsockets();
	create_buttons_weaponmanager();
	top_text = "MANAGE WEAPONS";
	image_index = 1;
}

create_buttons_modulemanager = function() {
	var spr = s_button_small;
	var sort_button = instance_create(x + 103 - sprite_get_width(spr)/2, y + 25 - sprite_get_height(spr)/2, o_button);
	sort_button.sprite_index = spr;
	sort_button.sprite = s_icon_sort;
	sort_button.on_press = function() {
		sort_itemlist(global.player_module_inventory);
		with (o_manage_ship_pane) {
			refresh();
		}
	}
	sort_button.depth = depth-1;
	sort_button.press_sound = snd_interface_pressbutton1;
	ds_list_add(buttons, sort_button);
}

create_buttons_weaponmanager = function() {
	var spr = s_button_small;
	var sort_button = instance_create(x + 103 - sprite_get_width(spr)/2, y + 25 - sprite_get_height(spr)/2, o_button);
	sort_button.sprite_index = spr;
	sort_button.sprite = s_icon_sort;
	sort_button.on_press = function() {
		sort_itemlist(global.player_weapon_inventory);
		with (o_manage_ship_pane) {
			refresh();
		}
	}
	sort_button.depth = depth-1;
	sort_button.press_sound = snd_interface_pressbutton1;
	ds_list_add(buttons, sort_button);
}

create_modulesockets = function() {
	var sh = global.editing_ship;
	var hgap = 10
	var vgap = 109;
	var bx = 206 + hgap;
	var yy = y + 50 + 25;
	var create_sockets_in_class = function(class_arr, class, sx, sy, gap) {
		var count = 0;
		for (var i = 0; i < array_length(class_arr); i++) {
			var ms = instance_create(x + sx + (gap+sprite_get_width(s_modulesocket))*count, sy, o_modulesocket);
			ms.class = class;
			ms.par = id;
			ms.target_arr = class_arr;
			ms.target_ind = i;
			ms.depth = depth - 1;
			if (class_arr[i] != noone) {
				var struct = global.itemlist_modules[? class_arr[i]];
				ms.assign_module(struct);
			}
			ds_list_add(sockets, ms);
			count++;
		}
	}
	create_sockets_in_class(sh.class1, 1, bx, yy, hgap);
	yy += vgap;
	create_sockets_in_class(sh.class2, 2, bx, yy, hgap);
	yy += vgap;
	create_sockets_in_class(sh.class3, 3, bx, yy, hgap);
	yy += vgap;
	create_sockets_in_class(sh.class4, 4, bx, yy, hgap);
	yy += vgap;
	create_sockets_in_class(sh.class5, 5, bx, yy, hgap);
	yy += vgap;
	create_sockets_in_class(sh.class6, 6, bx, yy, hgap);
}

create_weaponsockets = function() {
	var sh = global.editing_ship;
	var cx = 556, cy = 300;
	var ws_width = sprite_get_width(s_modulesocket);
	var ws_height = sprite_get_height(s_modulesocket);
	for (var i = 0; i < array_length(sh.hardpoints); i++) {
		var ws = instance_create(x + cx + sh.hardpoints[i][0] - ws_width/2, y + cy + sh.hardpoints[i][1] - ws_height/2, o_weaponsocket);
		ws.par = id;
		ws.target_ind = i;
		ws.depth = depth - 1;
		if (sh.hardpoint_objects[i] != noone) {
			var struct = global.itemlist_weapons[? sh.hardpoint_objects[i]];
			ws.assign_weapon(struct);
		}
		ds_list_add(sockets, ws);
	}
}

create_modulecards = function() {
	var pos = 0;
	var border_width = 3;
	var border_height = 51;
	var card_width = sprite_get_width(s_moduleframe);
	var card_height = sprite_get_height(s_moduleframe);
	// Set shop prices for the active list
	for (var i = 0; i < ds_list_size(global.player_module_inventory); i++) {
		var mc = instance_create(x + border_width, y + border_height + card_height * pos, o_modulecard);
		mc.struct = global.player_module_inventory[|i];
		mc.name = global.player_module_inventory[|i].name;
		mc.quantity = global.player_module_inventory[|i].quantity;
		mc.sprite = global.player_module_inventory[|i].sprite;
		mc.pos = i;
		mc.par = id;
		mc.y_cutoff = [y + sprite_height - 10, y];
		mc.class = global.player_module_inventory[|i].class;
		mc.depth = depth - 1;
		with (mc) {
			if ((struct.type == MODULETYPE_SHIELD && ship_has_shield(global.editing_ship)) ||
			    (struct.type == MODULETYPE_DRIVE && ship_has_drive(global.editing_ship)) ||
				(struct.type == MODULETYPE_WEPSYS && ship_has_wepsys(global.editing_ship))) {
			  invalid = true;
			}
		}
		ds_list_add(cards, mc);
		pos++;
	}
	with (o_modulecard) {
		if (y > y_cutoff[0] || y < y_cutoff[1]) {
			active = false;
		}
	}
}

create_weaponcards = function() {
	var pos = 0;
	var border_width = 3;
	var border_height = 51;
	var card_width = sprite_get_width(s_moduleframe);
	var card_height = sprite_get_height(s_moduleframe);
	// Set shop prices for the active list
	for (var i = 0; i < ds_list_size(global.player_weapon_inventory); i++) {
		var wc = instance_create(x + border_width, y + border_height + card_height * pos, o_weaponcard);
		wc.struct = global.player_weapon_inventory[|i];
		wc.name = global.player_weapon_inventory[|i].name;
		wc.quantity = global.player_weapon_inventory[|i].quantity;
		wc.sprite = global.player_weapon_inventory[|i].sprite;
		wc.pos = i;
		wc.par = id;
		wc.y_cutoff = [y + sprite_height - 10, y];
		wc.depth = depth - 1;
		ds_list_add(cards, wc);
		pos++;
	}
	with (o_weaponcard) {
		if (y > y_cutoff[0] || y < y_cutoff[1]) {
			active = false;
		}
	}
}

refresh = function() {
	switch (tab) {
		case open_tab.module :
			with (o_modulecard) {
				instance_destroy();
			}
			create_modulecards();
			with (o_modulecard) {
				y -= sprite_height*other.scroll;
				if (y > y_cutoff[0] || y < y_cutoff[1]) {
					active = false;
				} else {
					active = true;
				}
			}
			break;
		case open_tab.weapon :
			with (o_weaponcard) {
				instance_destroy();
			}
			create_weaponcards();
			with (o_weaponcard) {
				y -= sprite_height*other.scroll;
				if (y > y_cutoff[0] || y < y_cutoff[1]) {
					active = false;
				} else {
					active = true;
				}
			}
			break;
	}
}

leave = function() {
	if (tab == open_tab.module && !ship_has_drive(global.editing_ship)) {
		tooltip_make_generic("Your ship must have a drive module.");
		audio_play_sound(snd_interface_deadclick, 30, false);
	} else {
		settlement_reactivate_pane();
		instance_destroy();
		keyboard_clear(vk_escape);
	}
}

enum open_tab {
	module,
	weapon,
	ship
}
tab = open_tab.module;
global.editing_ship = struct_copy(global.player_ship, new ship(global.shiplist[? global.player_ship.info_id]));
scroll = 0;
cards = ds_list_create();
sockets = ds_list_create();
buttons = ds_list_create();
create_modulemanager();
top_text = "MANAGE MODULES";
items_displayed = 6;
scroll_cd_max = 10;
scroll_cd = scroll_cd_max;

var bspr = s_button_sidetab;
var bspr_height = sprite_get_height(bspr);
module_button = instance_create(x + sprite_width - 3, y + 50, o_button);
module_button.sprite_index = bspr;
module_button.sprite = s_icon_moduletab;
module_button.depth = depth - 1;
module_button.image_index = 1;
module_button.par = id;
module_button.on_press = function() {
	if (tab != open_tab.module) {
		create_modulemanager();
		audio_play_sound(snd_interface_pressbutton1, 30, false);
		module_button.depth = depth - 1;
		ship_button.depth = depth + 1;
		weapon_button.depth = depth + 1;
	}
}

weapon_button = instance_create(x + sprite_width - 3, y + 50 + bspr_height, o_button);
weapon_button.sprite_index = bspr;
weapon_button.sprite = s_icon_weapontab;
weapon_button.depth = depth + 1;
weapon_button.image_index = 1;
weapon_button.par = id;
weapon_button.on_press = function() {
	if (tab != open_tab.weapon) {
		create_weaponmanager();
		audio_play_sound(snd_interface_pressbutton1, 30, false);
		module_button.depth = depth + 1;
		ship_button.depth = depth + 1;
		weapon_button.depth = depth - 1;
	}
}

ship_button = instance_create(x + sprite_width - 3, y + 50 + 2*bspr_height , o_button);
ship_button.sprite_index = bspr;
ship_button.sprite = s_icon_shiptab;
ship_button.depth = depth + 1;
ship_button.image_index = 1;
ship_button.par = id;

close_button = instance_create(x + sprite_width - 64, y + 25 - sprite_get_height(s_button_small)/2, o_button);
close_button.sprite_index = s_button_small;
close_button.sprite = s_icon_exit;
close_button.depth = depth - 1;
close_button.par = id;
close_button.on_press = function() {
	leave();
}

audio_play_sound(snd_interface_open, 30, false);