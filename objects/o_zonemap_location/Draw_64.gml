/// @description Insert description here
// You can write your code in this editor
if (mouse_xprevious == mouse_x && mouse_yprevious == mouse_y) {
	tooltip_timer = max(0, tooltip_timer-1);
} else {
	tooltip_timer = tooltip_delay;
}

if (tooltip_timer == 0 && instance_exists(o_controller_zonemap) && o_controller_zonemap.selected_hex == hex) {
	draw_tooltip(MOUSE_GUIX + 32, MOUSE_GUIY + 32, struct.name, struct.tip_text);
}

mouse_xprevious = mouse_x;
mouse_yprevious = mouse_y;