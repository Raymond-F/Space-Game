// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
enum etags { // event tags
	always, // this event can always happen in any zone
	federation, // this event can happen in KFed territory
	empire, // this event can happen in Empire territory
	rebel, // this event can happen in Rebel territory
	pirate, // this event can happen in Pirate territory
	dust // this event can happen in hexes with dust clouds only
}

function event(_index, _filename, _tags, _rarity, _cooldown) constructor {
	static has_tag = function(tag) {
		return (array_find(tags, tag) >= 0);
	}
	
	index = _index; // The map index of this event
	filename = _filename; // The filename of the dialogue this event opens
	tags = _tags; // The tags of this event
	rarity = _rarity; // How rare is this event. This will proc the event iff random(rarity) < 1. If rarity is negative, this event will never trigger
	last_triggered = -99999999; // When this event was last triggered.
	cooldown = _cooldown; // How many turns in between this event triggering again. Negative means once ever
}

function initialize_event_list() {
	var em = ds_map_create();
	
	ds_map_add_unique(em, 0, new event(0, "dlg_event_find_derelict.txt", [etags.always], 1, 10));
	
	return em;
}

function choose_event() {
	var tg = global.zone_tags;
	if (global.player.hex.type == hex_type.dust) {
		array_push(tg, etags.dust);
	}
	var chosen_event = noone;
	do {
		var ev = global.event_list[? irandom(ds_map_size(global.event_list)-1)];
		var tag_valid = false;
		for (var i = 0; i < array_length(tg); i++) {
			var t = tg[i];
			if (ev.has_tag(t)) {
				tag_valid = true;
				break;
			}
		}
		if (!tag_valid) {
			continue;
		}
		if (ev.rarity <= 0 || random(ev.rarity) > 1) {
			continue;
		}
		if (global.current_turn < ev.last_triggered + ev.cooldown) {
			continue;
		}
		chosen_event = ev;
	} until (chosen_event != noone);
	chosen_event.last_triggered = global.current_turn;
	return chosen_event;
}

function event_trigger_random() {
	var e = choose_event();
	dsys_initialize_window(e.filename);
}