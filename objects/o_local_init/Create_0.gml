/// @description Insert description here
// You can write your code in this editor
global.pix = 3000;
global.crew = 20;
global.gunnery = 15;
global.maneuvering = 15;
global.leadership = 15;
global.tech = 15;
global.guts = 15;
global.wits = 15;
global.will = 15;
global.charm = 15;
setup = false;
instance_create(0,0,o_controller);
instance_create(0,0,o_gui);
zone_create(global.sector_map[? global.current_zone]);
// instance_create(VIEW_WIDTH/2, VIEW_HEIGHT/2, o_testshield);
// instance_create(0,0,o_testarc);

ambience = snd_ambience_zonemap;
global.ambience_id = audio_play_sound(ambience, 50, true);
audio_sound_gain(global.ambience_id, 0, 0);
audio_sound_gain(global.ambience_id, 1, 1000);