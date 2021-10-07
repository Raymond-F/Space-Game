/// @description Insert description here
// You can write your code in this editor
if(is_struct(dialogue)){
	dialogue.destroy();
	delete dialogue;
}
with(o_dialogue_optionbutton){
	instance_destroy();
}
for(var i = 0; i < ds_list_size(local_flags); i++){
	flag_remove(local_flags[|i]);
}
ds_list_destroy(local_flags);

instance_destroy(global.event_current_object);
global.event_current_object = noone;

with (o_controller_zonemap) {
	location_prompt_refresh();
}

audio_sound_gain(global.ambience_id, 1, 300);
audio_play_sound(snd_interface_close, 30, false);