/// @description Insert description here
// You can write your code in this editor
if (selected_hex != noone && selected_hex.vision = true) {
	var ind = 0;
	if(array_find(global.player.pathable_hexes, selected_hex) >= 0) {
		draw_set_alpha(0.15);
	} else {
		draw_set_alpha(0.1);
		ind = 1;
	}
	draw_sprite(s_zonemap_hexhighlight, ind, selected_hex.x, selected_hex.y);
	draw_set_alpha(1);
}

if (targeted_hex != noone && targeted_hex.vision = true) {
	draw_set_alpha(0.1);
	draw_sprite(s_zonemap_hexhighlight, 0, targeted_hex.x, targeted_hex.y);
	draw_set_alpha(1);
}