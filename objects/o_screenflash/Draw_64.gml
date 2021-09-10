/// @description Insert description here
// You can write your code in this editor
draw_set_alpha(alpha);
draw_rectangle(0, 0, GUIW, GUIH, false);
draw_set_alpha(1);
alpha -= 1/duration;
if(alpha <= 0) {
	instance_destroy();
}