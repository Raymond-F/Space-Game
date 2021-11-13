// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

//Construct a ship from a shipinfo struct
function ship(info) constructor {
	list = info.list;
	list_id = info.list_id;
	quantity = 1;
	stackable = false;
	name = info.name;
	struct_t = struct_type.ship;
	sprite = info.sprite;
	class1 = array_create(info.mod_slots[0], noone);
	class2 = array_create(info.mod_slots[1], noone);
	class3 = array_create(info.mod_slots[2], noone);
	class4 = array_create(info.mod_slots[3], noone);
	class5 = array_create(info.mod_slots[4], noone);
	class6 = array_create(info.mod_slots[5], noone);
	hardpoints = info.hardpoints; //relative coordinates of hardpoints
	hardpoint_objects = array_create(array_length(hardpoints), noone); //weapon objects stored in each hardpoint
	engines = info.engines;
	statistics = info.statistics;
	nickname = "";
}

//Load a random ship entry from the given file
function load_ship_from_file(fname){
	fname = "battles\\" + fname; //set to correct directory
	if(!file_exists(fname)){
		show_debug_message("ERROR: could not open file with filename: " + fname);
		return noone;
	}
	var file = file_text_open_read(fname);
	if(file < 0){
		return noone;
	}
	var layouts = [];
	var ncount = 0;
	while(!file_text_eof(file)){
		var line = "";
		var layout = [];
		var count = 0;
		do {
			line = file_text_readln(file);
			if(line != "\r\n" && line != "\n"){
				while(string_char_at(line, string_length(line)) == "\r" || string_char_at(line, string_length(line)) == "\n"){
					line = string_delete(line, string_length(line), 1);
				}
				layout[count] = line;
				count++;
			}
		} until (line == "\r\n" || line == "\n" || file_text_eof(file));
		layouts[ncount] = layout;
		ncount++;
	}
	//we should now have an array of each layout.
	file_text_close(file);
	var index = irandom(array_length(layouts)-1);
	var chosen = layouts[index];
	var _ship = noone, var _mods = []; var _weapons = [];
	for(var i = 0; i < array_length(chosen); i++){
		var line = chosen[i];
		var tokens = string_tokenize(line);
		switch(tokens[0]) {
			case "id" : {
				 _ship = int64(tokens[1]);
			} break;
			case "mods" : {
				for(var j = 1; j < array_length(tokens); j++) {
					_mods[j-1] = int64(tokens[j]);
				}
			} break;
			case "wep" : {
				for(var j = 1; j < array_length(tokens); j++) {
					_weapons[j-1] = int64(tokens[j]);
				}
			} break;
			case "loot" : {
				global.loot_file = tokens[1]; // File to generate loot from
				global.loot_rolls = round(int64(tokens[2]) * random_range(0.75, 1.25)); // Number of loot rolls
			}
			default: break;
		}
	}
	if(_ship == noone){
		show_debug_message("ERROR: Could not load ship ID from data file.")
		return;
	}
	var ship_struct = new ship(global.shiplist[? _ship]);
	var shield = noone;
	var drive = noone;
	var wepsys = noone;
	
	var mod_class_has_space = function(arr) {
		for(var _i = 0; _i < array_length(arr); _i++) {
			if(arr[_i] == noone) {
				return true;
			}
		}
		return false;
	}
	var place_mod_in_class = function(arr, val) {
		for(var _i = 0; _i < array_length(arr); _i++) {
			if(arr[_i] == noone) {
				arr[@ _i] = val;
				return;
			}
		}
		show_debug_message("ERROR: Could not place mod in class: Class full.");
	}
	
	for(var i = 0; i < array_length(_mods); i++) {
		var m = global.itemlist_modules[? _mods[i]];
		var mclass = m.class; //module class
		var placed = false;
		if(!placed && mclass <= 1 && mod_class_has_space(ship_struct.class1)) {
			place_mod_in_class(ship_struct.class1, m.list_id);
			placed = true;
		}
		if(!placed && mclass <= 2 && mod_class_has_space(ship_struct.class2)) {
			place_mod_in_class(ship_struct.class2, m.list_id);
			placed = true;
		}
		if(!placed && mclass <= 3 && mod_class_has_space(ship_struct.class3)) {
			place_mod_in_class(ship_struct.class3, m.list_id);
			placed = true;
		}
		if(!placed && mclass <= 4 && mod_class_has_space(ship_struct.class4)) {
			place_mod_in_class(ship_struct.class4, m.list_id);
			placed = true;
		}
		if(!placed && mclass <= 5 && mod_class_has_space(ship_struct.class5)) {
			place_mod_in_class(ship_struct.class5, m.list_id);
			placed = true;
		}
		if(!placed && mclass <= 6 && mod_class_has_space(ship_struct.class6)) {
			place_mod_in_class(ship_struct.class6, m.list_id);
			placed = true;
		}
		if(placed) {
			switch(m.stats.get_type()) {
				case "drive" : drive = m.list_id; break;
				case "shield" : shield = m.list_id; break;
				case "wepsys" : wepsys = m.list_id; break;
				default: break;
			}
		}
	}
	for(var i = 0; i < array_length(_weapons); i++) {
		if(i < array_length(ship_struct.hardpoints)) {
			ship_struct.hardpoint_objects[i] = _weapons[i];
		}
	}
	return ship_struct;
}

function player_ship_save() {
	
	var stringify_array = function(arr) {
		var str = "";
		for (var i = 0; i < array_length(arr); i++) {
			str += string(arr[i]);
			if (i < array_length(arr)-1) {
				str += " ";
			}
		}
		return str;
	}
	
	var fname = "saveinfo\\ship"; //set to correct directory
	if(file_exists(fname)){
		show_debug_message("Save data found. Deleting...");
		file_delete(fname);
	}
	var sh = global.player_ship;
	var file = file_text_open_write(fname);
	//ship saves like this:
	/*
		id
		class1
		class2
		class3
		class4
		class5
		class6
		hardpoint objects
	*/
	//the ship is always saved in this order. Be sure to update this comment as new ship stuff is added.
	file_text_write_string(file, string(sh.list_id));
	file_text_writeln(file);
	file_text_write_string(file, stringify_array(sh.class1));
	file_text_writeln(file);
	file_text_write_string(file, stringify_array(sh.class2));
	file_text_writeln(file);
	file_text_write_string(file, stringify_array(sh.class3));
	file_text_writeln(file);
	file_text_write_string(file, stringify_array(sh.class4));
	file_text_writeln(file);
	file_text_write_string(file, stringify_array(sh.class5));
	file_text_writeln(file);
	file_text_write_string(file, stringify_array(sh.class6));
	file_text_writeln(file);
	file_text_write_string(file, stringify_array(sh.hardpoint_objects));
	file_text_close(file);
}

function player_ship_load() {
	var fname = "saveinfo\\ship"; //set to correct directory
	if(!file_exists(fname)){
		show_debug_message("ERROR: could not open file with filename: " + fname);
		return noone;
	}
	var file = file_text_open_read(fname);
	if(file < 0){
		return noone;
	}
	var lines = [];
	var linecount = 0;
	while(!file_text_eof(file)){
		var line = "";
		line = file_text_readln(file);
		while(string_char_at(line, string_length(line)) == "\r" || string_char_at(line, string_length(line)) == "\n"){
			line = string_delete(line, string_length(line), 1);
		}
		lines[linecount] = line;
		linecount++;
	}
	//we should now have a set of arrays representing the player ship.
	file_text_close(file);
	var sh = new ship(global.shiplist[? int64(lines[0])]);
	sh.class1 = tokenize_to_int64(lines[1]);
	sh.class2 = tokenize_to_int64(lines[2]);
	sh.class3 = tokenize_to_int64(lines[3]);
	sh.class4 = tokenize_to_int64(lines[4]);
	sh.class5 = tokenize_to_int64(lines[5]);
	sh.class6 = tokenize_to_int64(lines[6]);
	sh.hardpoint_objects = tokenize_to_int64(lines[7]);
	global.player_ship = sh;
}