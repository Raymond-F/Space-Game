/// @description Insert description here
// You can write your code in this editor
if (MPRESSED(mb_right) && mouse_collision_gui() && transfer_target != noone) {
	inventory_transfer_item(current_target, transfer_target, pos, quantity);
	par.refresh();
}