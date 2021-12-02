/// @description Insert description here
// You can write your code in this editor
draw_set_color(c_white);
draw_set_alpha(flash_alpha);
draw_rectangle(0, 0, GUIW, GUIH, false);
draw_set_alpha(1);

if (timer >= 60) {
	flash_alpha -= 0.05;
} else {
	flash_alpha = clamp(flash_alpha + 1/60, 0, 1);
}