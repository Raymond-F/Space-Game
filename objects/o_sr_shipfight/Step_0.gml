/// @description Insert description here
// You can write your code in this editor
if (shots > 0 && shot_cd <= 0) {
	shots--;
	var shot = instance_create(winner.x_display, winner.y_display, o_zonemap_fightbullet);
	shot.image_angle = point_direction(winner.x_display, winner.y_display, loser.x_display, loser.y_display);
	shot.lifetime = shot_lifetime;
	shot.depth = -50;
	shot_cd = shot_cd_max;
}
shot_cd--;
timer--;
if (timer == 0) {
	ship_destroy_zonemap(loser);
	instance_destroy();
}