/// @description Insert description here
// You can write your code in this editor
var bg = s_spacebg_placeholder_zonemap;
var xpct = (VIEW_LEFT - global.camera_constraints[0] + VIEW_WIDTH/2) / (global.camera_constraints[2] - global.camera_constraints[0]);
var xpos = clamp(xpct*sprite_get_width(bg)/2, 0, sprite_get_width(bg)/2);
var ypct = (VIEW_TOP - global.camera_constraints[1] + VIEW_HEIGHT/2) / (global.camera_constraints[3] - global.camera_constraints[1]);
var ypos = clamp(ypct*sprite_get_height(bg)/2, 0, sprite_get_height(bg)/2);

var surf = surface_create(VIEW_WIDTH, VIEW_HEIGHT);
surface_set_target(surf);
surface_clear(surf);
with (o_zonemap_hex) {
	if (!explored) {
		draw_sprite(s_zonemap_unexp_hex, 0, x - VIEW_LEFT, y - VIEW_TOP);
	}
}
surface_reset_target();

draw_sprite(bg, 0, VIEW_LEFT-xpos, VIEW_TOP-ypos);
draw_surface(surf, VIEW_LEFT, VIEW_TOP);
surface_free(surf);