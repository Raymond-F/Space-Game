// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function gui_mouse_is_in_area(xx, yy, width, height){
	return point_in_rectangle(MOUSE_GUIX,MOUSE_GUIY,xx,yy,xx+width,yy+height);
}

function array_swap(arr, index1, index2) {
	var temp = arr[index1];
	arr[@ index1] = arr[index2];
	arr[@ index2] = temp;
}

function array_push_back(arr, val) {
	arr[@ array_length(arr)] = val;
}

function array_find(arr, val) {
	for (var i = 0; i < array_length(arr); i++) {
		if(arr[i] == val) {
			return i;
		}
	}
	return -1;
}

function array_contains(arr, val) {
	return (array_find(arr, val) >= 0);
}

//copy the members of an array from position start to position end, inclusive
function array_subset(arr, start, last) {
	if(start < 0 || last > array_length(arr)-1) {
		show_debug_message("ERROR: in array_copy - out of range");
	}
	if(start > last) {
		var t = start;
		start = last;
		last = t;
	}
	var newarr = array_create(last-start);
	for(var i = start; i <= last; i++) {
		newarr[i - start] = arr[i];
	}
	return newarr;
}

function ds_map_add_unique(_id, key, value) {
	if(ds_map_exists(_id, key)) {
		show_debug_message("WARNING: ds_map_add_unique tried to add non unique key: {key=" + string(key) + "} " + string(value));
		return;
	}
	ds_map_add(_id, key, value);
}

function tokenize_to_int64(str) {
	var arr = string_tokenize(str);
	for(var i = 0; i < array_length(arr); i++) {
		arr[i] = int64(arr[i]);
	}
	return arr;
}

// Copies the contents of `struct` into a struct of the same type `ref`.
function struct_copy(struct, ref) {
	var names = variable_struct_get_names(struct);
	for (var i = 0; i < array_length(names); i++) {
		variable_struct_set(ref, names[i], variable_struct_get(struct, names[i]));
	}
	return ref;
}

// Wrapper function for easy mouse GUI collision on UI objects
function mouse_collision_gui(obj = self) {
	with(obj) {
		return point_in_rectangle(MOUSE_GUIX, MOUSE_GUIY, bbox_left, bbox_top, bbox_right-1, bbox_bottom-1);
	}
}

// Get the nearest point of collision in a line from a source
// Source: https://yal.cc/gamemaker-collision-line-point/
function collision_line_nearest_point(x1, y1, x2, y2, object, prec, notme) {
	var qi = object;
	var qp = prec;
	var qn = notme
	var rr, rx, ry;
	rr = collision_line(x1, y1, x2, y2, qi, qp, qn);
	rx = x2;
	ry = y2;
	if (rr != noone) {
	    var p0 = 0;
	    var p1 = 1;
	    repeat (ceil(log2(point_distance(x1, y1, x2, y2))) + 1) {
	        var np = p0 + (p1 - p0) * 0.5;
	        var nx = x1 + (x2 - x1) * np;
	        var ny = y1 + (y2 - y1) * np;
	        var px = x1 + (x2 - x1) * p0;
	        var py = y1 + (y2 - y1) * p0;
	        var nr = collision_line(px, py, nx, ny, qi, qp, qn);
	        if (nr != noone) {
	            rr = nr;
	            rx = nx;
	            ry = ny;
	            p1 = np;
	        } else p0 = np;
	    }
	}
	var r;
	r[0] = rr;
	r[1] = rx;
	r[2] = ry;
	return r;
}

// Copies the `choose` function, but from an array rather than a strict listing
function array_choose(arr) {
	if (array_length(arr) == 0) {
		return noone;
	}
	return arr[irandom(array_length(arr)-1)];
}

// Makes a 2d array of the specified dimensions, filled with the given value
function array_2d_create(dim1, dim2, val) {
	var arr = array_create(dim1);
	for (var i = 0; i < dim1; i++) {
		arr[i] = array_create(dim2, val);
	}
	return arr;
}

// Grabs the zone struct of the current zone
function zone_get_current() {
	return global.sector_map[? global.current_zone];
}

// Choose a value with weighting. Structured as [v1, c1, v2, c2, v3, c3,...]
function choose_weighted() {
	var c = argument_count;
	var total = 0;
	for (var i = 1; i < c; i += 2) {
		total += argument[i];
	}
	var roll = random(total);
	var val = 0;
	for (var i = 0; i < c; i += 2) {
		val += argument[i+1];
		if (val >= roll) {
			return argument[i];
		}
	}
	return argument[0];
}

// Read a file line by line and return an array of those strings
function file_parse_lines(fname){
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
		var line = file_text_readln(file);
		while(string_char_at(line, string_length(line)) == "\r" || string_char_at(line, string_length(line)) == "\n"){
			line = string_delete(line, string_length(line), 1);
		}
		lines[linecount] = line;
		linecount++;
	}
	//we should now have an array of each node object.
	file_text_close(file);
	return lines;
}

// Create a generic tooltip and flash it to the screen.
function tooltip_make_generic(text) {
	with(o_tooltip_generic) {
		instance_destroy();
	}
	var tt = instance_create(0, 0, o_tooltip_generic);
	tt.text = text;
}

// Start up the ambient background noise.
function start_ambience() {
	ambience = snd_ambience_zonemap;
	global.ambience_id = audio_play_sound(ambience, 50, true);
	audio_sound_gain(global.ambience_id, 0, 0);
	audio_sound_gain(global.ambience_id, 1, 1000);
}

function dif(val1, val2) {
	return abs(val1 - val2);
}