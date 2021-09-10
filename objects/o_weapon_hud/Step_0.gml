/// @description Insert description here
// You can write your code in this editor
if (!instance_exists(wep)) {
	exit;
}
if (MPRESSED(mb_left) &&
	point_in_rectangle(MOUSE_GUIX, MOUSE_GUIY, x, y, x+sprite_width, y+sprite_height)) {
  wep.fire = !wep.fire;
  wep.autofire = false;
}
else if (MPRESSED(mb_right) &&
	point_in_rectangle(MOUSE_GUIX, MOUSE_GUIY, x, y, x+sprite_width, y+sprite_height)) {
  wep.autofire = !wep.autofire;
  wep.fire = false;
}