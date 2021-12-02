/// @description Insert description here
// You can write your code in this editor
if (hex.explored == false) {
	exit;
} else if (type == location_type.event && !hex.vision) {
	exit;
}
if (sprite_index > 0) {
	draw_self();
} else {
	show_debug_message("Location draw event failed: no sprite");
}