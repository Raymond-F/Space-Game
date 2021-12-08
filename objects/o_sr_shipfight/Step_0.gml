/// @description Insert description here
// You can write your code in this editor
if (shots > 0 && shot_cd <= 0) {
	shots--;
	var shot = instance_create_depth(winner.x_display, winner.y_display, -y - 500, o_zonemap_fightbullet);
	shot.image_angle = point_direction(winner.x_display, winner.y_display, loser.x_display, loser.y_display);
	shot.lifetime = shot_lifetime;
	shot_cd = shot_cd_max;
}
shot_cd--;
timer--;
if (timer == 0) {
	var explosion = instance_create_depth(loser.x_display, loser.y_display, loser.depth - 1, o_explosion);
	explosion.image_xscale = 2;
	explosion.image_yscale = 2;
	ship_destroy_zonemap(loser);
	instance_destroy();
}