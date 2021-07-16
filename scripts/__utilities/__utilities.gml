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
