/// @description Insert description here
// You can write your code in this editor
if(tooltip_timer == 0) {
	var tip_text = "";
	if(ds_map_exists(global.tooltips, name)) {
		tip_text = global.tooltips[? name];
	}
	draw_tooltip(MOUSE_GUIX + 32, MOUSE_GUIY + 32, name, tip_text);
}