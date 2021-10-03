/// @description Insert description here
// You can write your code in this editor
if (mouse_x == mouse_xprevious && mouse_y == mouse_yprevious) {
	tooltip_timer = max(tooltip_timer-1, 0);
} else {
	tooltip_timer = tooltip_delay;
}

if (mouse_collision_gui()) {
	if (MPRESSED(mb_right) && transfer_target != noone) {
		var transfer_qty = 1;
		if (HELD(vk_control)) {
			transfer_qty = quantity;
		} else if (HELD(vk_shift)) {
			transfer_qty = min(quantity, 10)
		}
		if (buying) {
			var max_affordable = floor(global.pix / value);
			transfer_qty = min(max_affordable, transfer_qty);
		}
		inventory_transfer_item(current_target, transfer_target, pos, transfer_qty);
		if (buying) {
			global.pix -= value * transfer_qty;
		} else if (selling) {
			global.pix += value * transfer_qty;
		}
		par.refresh();
	}
} else {
	tooltip_timer = tooltip_delay;
}

mouse_xprevious = mouse_x;
mouse_yprevious = mouse_y;