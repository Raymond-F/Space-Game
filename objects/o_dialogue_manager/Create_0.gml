/// @description Insert description here
// You can write your code in this editor
dialogue = noone;
avatar = s_testavatar;
speaker = "";
text = "";
options = [];
depth = -10;
width = sprite_get_width(s_dialogue_pane);
height = sprite_get_height(s_dialogue_pane);
cost_string = "";
local_flags = ds_list_create();

audio_sound_gain(global.ambience_id, 0.5, 300);
audio_play_sound(snd_interface_open, 30, false);