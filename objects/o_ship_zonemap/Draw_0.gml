/// @description Insert description here
// You can write your code in this editor
if (!draw_setup) {
	draw_setup = true;
	switch(faction) {
		case factions.empire: sprite_index = s_zonemap_ship_empire; break;
		case factions.kfed: sprite_index = s_zonemap_ship_kfed; break;
		case factions.pirate: sprite_index = s_zonemap_ship_pirate; break;
		case factions.rebel: sprite_index = s_zonemap_ship_rebel; break;
		case factions.civilian: sprite_index = s_zonemap_ship_civilian; break;
	}
	image_speed = 0;
}
var current_hex = hex;
if (x != tx || y != ty) {
	var current_hex = instance_place(x, y, o_zonemap_hex);
}
if (!active) {
	inactive_fade_delay--;
}
if (current_hex.vision && inactive_fade_delay > 0) {
	image_alpha = min(1, image_alpha+0.1);
} else {
	image_alpha = max(0, image_alpha-0.1);
}
if (!active && inactive_fade_delay <= 0 && image_alpha == 0) {
	ship_destroy_zonemap(id);
}
if (global.debug) {
	if (target != noone) {
		draw_set_color(c_green);
		draw_line(x, y, target.x, target.y);
		draw_circle(target.x, target.y, 5, false);
		draw_set_color(c_white);
	}
	var pa = image_alpha;
	image_alpha = 1;
	draw_self_ship();
	image_alpha = pa;
} else {
	draw_self_ship();
}
if (is_bounty_target && hex.vision) {
	draw_sprite_ext(s_icon_targetcrosshair, 0, x_display, y_display, 0.25, 0.25, get_timer() / 50000, c_white, image_alpha);
}