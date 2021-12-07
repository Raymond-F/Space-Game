/// @description Insert description here
// You can write your code in this editor
draw_self();
draw_set_font(fnt_gui_big);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text(x + sprite_width/2, y + 26, top_text);

draw_set_font(fnt_gui_big);
draw_text(x + sprite_width/2, y + 76, "CURRENT:");
draw_text(x + sprite_width/2, y + 305, "AVAILABLE:");

if (global.current_contract == noone) {
	draw_set_font(fnt_dialogue);
	draw_text(x + sprite_width/2, y + 186, "Once you accept a contract it will appear here.");
}

if (ds_list_size(global.active_settlement.struct.contracts) == 0) {
	draw_text(x + sprite_width/2, y + 597, "There are no contracts here at the moment. Try coming back later.");
}