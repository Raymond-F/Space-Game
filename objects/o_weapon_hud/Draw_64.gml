/// @description Insert description here
// You can write your code in this editor
draw_self();
if(instance_exists(wep)){
	draw_progress_bar(x+12, y+6, x+sprite_width-32, y+20, 3, c_white, c_white, wep.charge, wep.charge_max);
	draw_set_valign(fa_bottom)
	draw_text(x+12,y+sprite_height-4,wep.name);
	var fire_sprite;
	if (wep.autofire) {
		fire_sprite = s_icon_autofire;
	} else if (wep.fire) {
		fire_sprite = s_icon_fire;
	} else {
		fire_sprite = s_icon_nofire;
	}
	draw_sprite(fire_sprite, 0, x+sprite_width-24, y+6);
	if (point_in_rectangle(MOUSE_GUIX, MOUSE_GUIY, x, y, x+sprite_width, y+sprite_height)) {
		shader_set(sh_to_white);
		var u_alpha = shader_get_uniform(sh_to_white, "draw_alpha");
		shader_set_uniform_f(u_alpha, 0.4);
		draw_self();
		shader_reset();
	}
}
else {
	draw_text(x+4,y+4,"Empty");
}