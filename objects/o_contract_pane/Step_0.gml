/// @description Insert description here
// You can write your code in this editor

if (PRESSED(vk_escape)) {
	settlement_reactivate_pane();
	instance_destroy();
	keyboard_clear(vk_escape);
}