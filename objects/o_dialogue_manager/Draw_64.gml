/// @description Insert description here
// You can write your code in this editor
draw_set_font(fnt_dialogue);
x = GUIW/2 - width/2;
y = GUIH/2 - height/2;
draw_sprite(s_dialogue_pane, 0, x, y);

var border_size = 3;
var lborder = border_size;
var rborder = sprite_width-border_size;
var tborder = border_size;
var bborder = sprite_height-border_size;
var avatar_width = 295;
var avatar_height = 346;
var speaker_box_height = 40;
var text_padding = 20;


if(avatar != noone){
	draw_sprite(avatar, 0, x+border_size, y+border_size);
}
draw_set_alpha(0.7);
draw_set_color(c_black);
draw_rectangle(x+border_size, y+border_size+avatar_height, x+border_size+avatar_width, y+border_size+avatar_height-speaker_box_height, false);
draw_set_color(C_DIALOGUE);
draw_set_alpha(1);
draw_align_center();
draw_text(x + (border_size*2+avatar_width)/2, y + (border_size*2+avatar_height*2-speaker_box_height)/2, speaker);
draw_align_reset();
draw_text_ext(x + border_size*2 + avatar_width + text_padding, y + border_size + text_padding, text, -1, sprite_width-border_size*2 - avatar_width - text_padding*2);