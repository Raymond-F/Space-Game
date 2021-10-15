/// @description Insert description here
// You can write your code in this editor
if (mouse_x == mouse_xprevious && mouse_y == mouse_yprevious) {
	tooltip_timer = max(tooltip_timer-1, 0);
} else {
	tooltip_timer = tooltip_delay;
}

if (mouse_collision_gui() && MPRESSED(mb_right) && active) {
	// TODO: Swap ships
} else {
	tooltip_timer = tooltip_delay;
}

mouse_xprevious = mouse_x;
mouse_yprevious = mouse_y;