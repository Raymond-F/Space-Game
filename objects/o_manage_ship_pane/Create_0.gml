/// @description Insert description here
// You can write your code in this editor
create_modulemanager = function() {
	create_modulecards();
	create_modulesockets();
	create_buttons();
}

create_buttons = function() {
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

refresh = function() {
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
}

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

audio_play_sound(snd_interface_open, 30, false);