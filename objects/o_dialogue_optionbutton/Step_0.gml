/// @description Insert description here
// You can write your code in this editor
if(active && MPRESSED(mb_left)){
	if(gui_mouse_is_in_area(x, y, width, height)){
		// Post-event handling. This should probably be somewhere else rather than stapled in here... Oh well!
		if (postevent_location != noone && global.event_current_object != noone) {
			var copy_event_object_details = function(loc) {
				loc.x = global.event_current_object.x;
				loc.y = global.event_current_object.y;
				loc.hex = global.event_current_object.hex;
				loc.gx = global.event_current_object.gx;
				loc.struct.gx = loc.gx;
				loc.gy = global.event_current_object.gy;
				loc.struct.gy = loc.gy;
				loc.struct.obj = loc;
			}
			switch (postevent_location) {
				case location_type.derelict:
					var d = place_derelict(zone_get_current());
					var loc = location_create(d, instance_nearest(0, 0, o_controller_zonemap));
					copy_event_object_details(loc);
					loc.sprite_index = s_zonemap_derelict;
					break;
				case location_type.comet:
					var c = place_comet(zone_get_current());
					var loc = location_create(c, instance_nearest(0, 0, o_controller_zonemap));
					copy_event_object_details(loc);
					loc.sprite_index = s_zonemap_comet;
					break;
				default: break;
			}
		}
		if (link_type == option_link_type.dialogue) {
			if(link == ""){
				with(parent){
					instance_destroy();
				}
			}
			else {
				dsys_set_node(parent, link, id);
			}
		} else if (link_type == option_link_type.battle) {
			global.battle_file = link;
			global.postbattle_file = postbattle_file;
			combat_setup();
			with (parent) {
				instance_destroy();
			}
		}
		mouse_clear(mb_left);
		audio_play_sound(snd_interface_pressbutton1, 30, false);
	}
} else if (!active && MPRESSED(mb_left)){
	audio_play_sound(snd_interface_deadclick, 30, false);
}