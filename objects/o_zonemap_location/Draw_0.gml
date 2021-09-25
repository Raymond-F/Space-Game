/// @description Insert description here
// You can write your code in this editor
if (hex.explored == false) {
	exit;
} else if (type == location_type.event && !hex.vision) {
	exit;
}
draw_self();