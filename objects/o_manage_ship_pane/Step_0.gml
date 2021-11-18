/// @description Insert description here
// You can write your code in this editor
scroll_cd = max(scroll_cd-1, 0);

if (((global.dragged_module != noone && global.dragged_module.object_index == o_modulesocket) ||
	 (global.dragged_weapon != noone && global.dragged_weapon.object_index == o_weaponsocket)) &&
	 !instance_exists(o_modulecard_list_dropbox)) {
	var db = instance_create(0, 0, o_modulecard_list_dropbox);
	// Values are arbitrary magic numbers based on UI sprite. Tee hee.
	with (db) {
		coords[0] = other.x + 3;
		coords[1] = other.y + 51;
		coords[2] = other.x + 202;
		coords[3] = other.y + 696;
	}
}

if(mouse_wheel_down()) {
	var list;
	switch (tab) {
		case open_tab.module : list = global.player_module_inventory; break;
		case open_tab.weapon : list = global.player_weapon_inventory; break;
		case open_tab.ship : list = global.player_ship_inventory; break;
	}
	var count = ds_list_size(list);
	if (count > items_displayed + scroll) {
		scroll++;
		var move_up = function() {
			y -= sprite_height;
			if(y < y_cutoff[1]) {
				active = false;
			} else if (y < y_cutoff[0]) {
				active = true;
			}
		}
		with(o_modulecard) {
			move_up();
		}
		with(o_weaponcard) {
			move_up();
		}
		with(o_shipcard) {
			move_up();
		}
		scroll_cd = scroll_cd_max;
	}
}

if(mouse_wheel_up()) {
	if (scroll > 0) {
		scroll--;
		var move_down = function() {
			y += sprite_height;
			if(y > y_cutoff[0]) {
				active = false;
			} else if (y > y_cutoff[1]) {
				active = true;
			}
		}
		with(o_modulecard) {
			move_down();
		}
		with(o_weaponcard) {
			move_down();
		}
		with(o_shipcard) {
			move_down();
		}
		scroll_cd = scroll_cd_max;
	}
}

if (PRESSED(vk_escape)) {
	leave();
}