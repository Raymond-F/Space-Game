/// @description Insert description here
// You can write your code in this editor
if (mouse_in_area()) {
	if (!highlighted) {
		highlighted = true;
		//update = true;
	}
} else if (highlighted) {
	highlighted = false;
	//update = true;
}