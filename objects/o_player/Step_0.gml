/// @description Insert description here
// You can write your code in this editor
if (point_distance(x, y, tx, ty) > 1) {
	image_angle = point_direction(x, y, tx, ty);
}
x = lerp(x, tx, 0.1);
y = lerp(y, ty, 0.1);