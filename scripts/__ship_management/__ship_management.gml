// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

// Gets a list of all modules in all classes from a given ship.
function ship_get_full_modules_list(sh) {
	var arr = [];
	static add_modules_to_arr = function(class_arr, list) {
		for (var i = 0; i < array_length(class_arr); i++) {
			if(class_arr[i] != noone){
				array_push(list, class_arr[i]);
			}
		}
	}
	add_modules_to_arr(sh.class1, arr);
	add_modules_to_arr(sh.class2, arr);
	add_modules_to_arr(sh.class3, arr);
	add_modules_to_arr(sh.class4, arr);
	add_modules_to_arr(sh.class5, arr);
	add_modules_to_arr(sh.class6, arr);
	return arr;
}

// Returns whether or not the ship has a drive module.
// Ships must have a drive module to exit the management screen.
function ship_has_drive(sh){
	var l = ship_get_full_modules_list(sh);
	for (var i = 0; i < array_length(l); i++) {
		var mdl = global.itemlist_modules[? l[i]];
		if (mdl.type == MODULETYPE_DRIVE) {
			return true;
		}
	}
	return false;
}

// Returns whether or not the ship has a shield module.
function ship_has_shield(sh){
	var l = ship_get_full_modules_list(sh);
	for (var i = 0; i < array_length(l); i++) {
		var mdl = global.itemlist_modules[? l[i]];
		if (mdl.type == MODULETYPE_SHIELD) {
			return true;
		}
	}
	return false;
}

// Returns whether or not the ship has a weapon system.
function ship_has_wepsys(sh){
	var l = ship_get_full_modules_list(sh);
	for (var i = 0; i < array_length(l); i++) {
		var mdl = global.itemlist_modules[? l[i]];
		if (mdl.type == MODULETYPE_WEPSYS) {
			return true;
		}
	}
	return false;
}

// Returns whether or not the ship has a specific module. Some modules do not allow duplicates.
function ship_has_module(sh, module_id) {
	var l = ship_get_full_modules_list(sh);
	for (var i = 0; i < array_length(l); i++) {
		var mdl = global.itemlist_modules[? l[i]];
		if (mdl.list_id == module_id) {
			return true;
		}
	}
	return false;
}

// Tests whether a module is valid to be placed
// `mdl` argument is module struct.
function module_addition_valid(sh, mdl) {
	switch (mdl.type) {
		case MODULETYPE_DRIVE: return !ship_has_drive(sh); break;
		case MODULETYPE_SHIELD: return !ship_has_shield(sh); break;
		case MODULETYPE_WEPSYS: return !ship_has_wepsys(sh); break;
		default: break;
	}
	return true;
}

// Similar to above but further checks if, when not baseline valid, this module is valid conditionally
// on replacing a given module. This is the case for things like replacing a drive module with another
// drive module.
function module_replacement_valid(sh, mdl, replaced) {
	if (module_addition_valid(sh, mdl)) {
		return true;
	} else {
		if (mdl.type != MODULETYPE_OTHER && mdl.type == replaced.type) {
			return true;
		}
	}
	return false;
}

function ship_get_nickname(sh_struct) {
	var name = sh_struct.nickname;
	if (name == "") {
		name = "Unnamed Vessel";
	}
	return name;
}