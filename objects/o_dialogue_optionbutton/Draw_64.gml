/// @description Insert description here
// You can write your code in this editor
x = o_dialogue_manager.x + 3;
y = o_dialogue_manager.y + 352 + (index * height);
if(active){
	draw_sprite(s_dialogue_optionbutton, 0, x, y);
}
else {
	draw_sprite(s_dialogue_optionbutton_inactive, 0, x, y);
}
if(active && gui_mouse_is_in_area(x, y, width, height)){
	draw_set_alpha(0.1);
	draw_set_color(c_white);
	draw_rectangle(x, y, x+width, y+height, false);
	draw_set_alpha(1);
}
draw_align_center();
draw_set_font(fnt_dialogue);
draw_set_color(C_DIALOGUE);
draw_text_special(x + width/2, y + height/2, text + cost_string + gain_string + activity_string, fa_center, fa_middle, fnt_dialogue);