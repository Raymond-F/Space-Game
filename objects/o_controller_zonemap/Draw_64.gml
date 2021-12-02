/// @description Insert description here
// You can write your code in this editor
if (location_prompt_text != "" && !instance_exists(par_interface) && global.context == context.zone_map) {
	var ytarget = GUIH - sprite_get_height(s_location_prompt);
	location_prompt_y = lerp(location_prompt_y, ytarget, 0.2);
	if (abs(location_prompt_y - ytarget) < 0.5) {
		location_prompt_y = ytarget+0.5;
	}
	draw_sprite(s_location_prompt, 0, round(location_prompt_x), round(location_prompt_y));
	location_prompt_button.y = round(location_prompt_y);
	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	draw_set_color(c_white);
	draw_set_font(fnt_dialogue_big);
	draw_text(GUIW/2, location_prompt_y + sprite_get_height(s_button_large)*1.25, location_prompt_name);
	draw_set_font(fnt_dialogue);
	draw_text_ext(GUIW/2, location_prompt_y + sprite_get_height(s_button_large)*1.25 + string_height(location_prompt_name)*1.5,
				  location_prompt_text, -1, sprite_get_width(s_location_prompt) - 26);
} else {
	location_prompt_y = GUIH;
	location_prompt_button.y = GUIH;
}

if (ai_turn) {
	wait_indicator_alpha = min(1, wait_indicator_alpha + 0.1);
} else {
	wait_indicator_alpha = max(0, wait_indicator_alpha - 0.1);
}
if (!instance_exists(par_interface)) {
	draw_set_alpha(wait_indicator_alpha);
	draw_sprite(s_icon_wait, 0, GUIW/2, GUIH*4/5);
	draw_set_alpha(1);
}
if (global.debug) {
	draw_set_halign(fa_right);
	draw_set_color(c_white);
	draw_text(GUIW - 10, 100, "AI DELAY TIMER: " + string(ai_delay));
	draw_align_reset();
}