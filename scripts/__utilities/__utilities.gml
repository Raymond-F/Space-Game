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

function color_interpolate(c1, c2, amount) {
	var r1 = (c1 & c_red);
	var r2 = (c2 & c_red);
	var g1 = (c1 & c_lime) >> 8;
	var g2 = (c2 & c_lime) >> 8;
	var b1 = (c1 & c_blue) >> 16;
	var b2 = (c2 & c_blue) >> 16;

	var blue = round(lerp(b1,b2,amount));
	var green = round(lerp(g1,g2,amount));
	var red = round(lerp(r1,r2,amount));
	return (blue << 16) + (green << 8) + red;
}

function ds_map_add_unique(_id, key, value) {
	if(ds_map_exists(_id, key)) {
		show_debug_message("WARNING: ds_map_add_unique tried to add non unique key: {key=" + string(key) + "} " + string(value));
		return;
	}
	ds_map_add(_id, key, value);
}

function draw_progress_bar(x1, y1, x2, y2, border_width, fill_color, border_color, current_val, target_val, inverted = false) {
	var pcolor = draw_get_color();
	if(abs(y2 - y1) <= (border_width+1)*2 + 1 || abs(x2 - x1) <= (border_width+1)*2 + 1) {
		return;
	}
	if(border_width < 0) border_width = 0;
	if(x1 > x2) {
		var t = x1;
		x1 = x2;
		x2 = t;
	}
	if(y1 > y2) {
		var t = y1;
		y1 = y2;
		y2 = t;
	}
	var pct = clamp(current_val/target_val, 0, 1);
	draw_set_color(border_color);
	var xs = x1, xe = x2, ys = y1, ye = y2;
	repeat(border_width) {
		draw_rectangle(xs, ys, xe, ye, true);
		xs++;
		xe--;
		ys++;
		ye--;
	}
	xs++;
	xe--;
	ys++;
	ye--;
	var bar_width = xe - xs;
	var filled_length = round(bar_width * pct);
	if (pct > 0) {
		draw_set_color(fill_color);
		if (inverted) {
			draw_rectangle(xe, ys, xe - filled_length, ye, false);
		} else {
			draw_rectangle(xs, ys, xs + filled_length, ye, false);
		}
	}
	draw_set_color(pcolor);
}

function tokenize_to_int64(str) {
	var arr = string_tokenize(str);
	for(var i = 0; i < array_length(arr); i++) {
		arr[i] = int64(arr[i]);
	}
	return arr;
}

// Creates a new struct and copies each member of `struct` into it. The struct will be of type
// c_type
function struct_copy(struct, c_type) {
	var n = new c_type();
	var names = variable_struct_get_names(struct);
	for (var i = 0; i < array_length(names); i++) {
		variable_struct_set(n, names[i], variable_struct_get(struct, names[i]));
	}
	return n;
}

// Wrapper function for easy mouse GUI collision on UI objects
function mouse_collision_gui(obj = self) {
	with(obj) {
		return point_in_rectangle(MOUSE_GUIX, MOUSE_GUIY, bbox_left, bbox_top, bbox_right, bbox_bottom);
	}
}