/// @description Insert description here
// You can write your code in this editor
draw_self();
draw_set_valign(fa_bottom)
draw_set_halign(fa_left);
draw_set_color(c_white);
if(instance_exists(wep)){
	draw_progress_bar(x+12, y+6, x+sprite_width-32, y+20, 3, c_white, c_white, wep.charge, wep.charge_max);
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
		// Draw highlight line
		draw_set_color(c_white);
		var is_enemy = (x > wep.x);
		var px, py;
		px = is_enemy ? x : x + sprite_width - 2;
		py = y + sprite_height/2;
		draw_circle(px, py, 1.75, false);
		var px2 = is_enemy ? px - 20 : px + 20;
		draw_line_width(px, py, px2, py, 1);
		draw_circle(px2, py, 0.5, false);
		var py2 = point_y_to_gui(wep.y);
		draw_line_width(px2, py, px2, py2, 1);
		draw_circle(px2, py2, 0.5, false);
		var px3 = point_x_to_gui(wep.x);
		draw_line_width(px2, py2, px3, py2, 1);
		draw_circle(px3, py2, 1.75, false);
	}
}
else {
	draw_text(x+4,y+4,"Empty");
}