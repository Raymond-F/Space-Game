/// @description Insert description here
// You can write your code in this editor
if (mouse_x == mouse_xprevious && mouse_y == mouse_yprevious) {
	tooltip_timer = max(tooltip_timer-1, 0);
} else {
	tooltip_timer = tooltip_delay;
}

if (mouse_collision_gui()) {
	if (MPRESSED(mb_right) && transfer_target != noone) {
		inventory_transfer_item(current_target, transfer_target, pos, quantity);
		par.refresh();
	}
} else {
	tooltip_timer = tooltip_delay;
}

mouse_xprevious = mouse_x;
mouse_yprevious = mouse_y;