/// @description Insert description here
// You can write your code in this editor
if (!setup) {
	setup = true;
	
	if (target == noone) {
		instance_destroy();
	} else if (target.object_index = o_ship_zonemap) {
		var spr = s_button_contextmenu;
		var ydif = sprite_get_height(spr);
		
		var hail = instance_create(x, y, o_button);
		hail.sprite_index = spr;
		hail.text = "HAIL";
		hail.on_press = function() {
			global.local_ship = target;
			with (o_controller_zonemap) {
				player_move(global.local_ship.hex, player_actions.hail);
			}
		}
		array_push(buttons, hail);
		
		var att = instance_create(x, y + ydif, o_button);
		att.sprite_index = spr;
		att.text = "ATTACK";
		att.on_press = function() {
			if (!factions_are_enemies(factions.player, target.faction)) {
				var p = instance_create(GUIW/2 - sprite_get_width(s_prompt_generic)/2, GUIH/2 - sprite_get_height(s_prompt_generic), o_prompt);
				p.top_text = "Really Attack?";
				p.tip_text = "This ship belongs to a faction that you are not currently enemies with. They won't appreciate you attacking one of their ships, and may become hostile. Proceed?";
				p.on_close = function() {
					if (other.confirmed) {
						global.local_ship = target;
						with (o_controller_zonemap) {
							player_move(global.local_ship.hex, player_actions.attack);
						}
					}
				}
			} else {
				global.local_ship = target;
				with (o_controller_zonemap) {
					player_move(global.local_ship.hex, player_actions.attack);
				}
			}
		}
		array_push(buttons, att);
		
		var move = instance_create(x, y + 2*ydif, o_button);
		move.sprite_index = spr;
		move.text = "MOVE";
		move.on_press = function() {
			var t = target;
			with (o_controller_zonemap) {
				player_move(t.hex);
			}
		}
		array_push(buttons, move);
	} else {
		instance_destroy();
	}
}