/// @description Insert description here
// You can write your code in this editor

if (hex.explored == false) {
	exit;
} else if (type == location_type.event && !hex.vision) {
	exit;
}
if (type != location_type.settlement) {
	if (sprite_index >= 0) {
		draw_self();
	} else {
		show_debug_message("Location draw event failed: no sprite");
	}
}

// Draw target crosshair if there is a contract to be turned in here.
if (global.current_contract != noone &&
      global.current_contract.stage == global.current_contract.last_stage &&
	  global.current_contract.end_loc == struct) {
	draw_sprite_ext(s_icon_targetcrosshair, 0, x, y, 0.25, 0.25, sin(get_timer() / 50000), c_white, 1);
}