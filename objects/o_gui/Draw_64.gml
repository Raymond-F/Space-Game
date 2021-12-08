/// @description Insert description here
// You can write your code in this editor
draw_set_font(fnt_gui);
draw_set_color(c_white);
draw_align_reset();
draw_set_valign(fa_middle);
draw_set_alpha(1);
if(!instance_exists(o_sr_zone_transition) && (global.context == context.zone_map || global.context == context.sector_map)) {
	var offset = 0;
	var offset_inc = 30;
	draw_sprite(s_icon_pix_medium, 0, 12, 12 + offset);
	offset += offset_inc;
	draw_sprite(s_icon_crew_medium, 0, 12, 12 + offset);
	offset += offset_inc;
	draw_sprite(s_icon_supplies_medium, 0, 12, 12 + offset);
	offset += offset_inc;
	draw_sprite(s_icon_fuel_medium, 0, 12, 12 + offset);
	offset = 0;
	draw_text(34 + sprite_get_width(s_icon_pix_medium)/2, 24 + offset, string(global.pix));
	offset += offset_inc;
	draw_text(34 + sprite_get_width(s_icon_crew_medium)/2, 24 + offset, string(global.crew));
	offset += offset_inc;
	draw_text(34 + sprite_get_width(s_icon_supplies_medium)/2, 24 + offset, string(global.supplies));
	offset += offset_inc;
	draw_text(34 + sprite_get_width(s_icon_fuel_medium)/2, 24 + offset, string(global.fuel));
	
	// Contract display
	if (global.current_contract != noone) {
		var cnt = global.current_contract;
		var bw = 300;
		var bh = 60;
		var bx = GUIW - bw - 10;
		var by = 10;
		var str = "- " + cnt.stage_strings[cnt.stage];
		draw_set_font(fnt_dialogue);
		bh += string_height_ext(str, -1, bw - 20);
		tooltip_draw_background(bx, by, bx + bw, by + bh);
		draw_set_font(fnt_gui);
		draw_set_halign(fa_center);
		draw_text(bx + bw/2, by + 20, cnt.name);
		draw_set_color(C_WINDOW_HIGHLIGHT);
		draw_line(bx+1, by + 36, bx + bw - 1, by + 36);
		draw_set_font(fnt_dialogue);
		draw_set_color(c_white);
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		/*for (var i = 0; i <= cnt.stage; i++) {
			bh += string_height_ext(cnt.stage_strings[i], -1, bw - 20) + 8;
		}*/
		draw_text_ext(bx + 10, by + 50, str, -1, bw - 20);
	}
}