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