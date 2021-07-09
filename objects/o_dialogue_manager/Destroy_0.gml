/// @description Insert description here
// You can write your code in this editor
if(is_struct(dialogue)){
	dialogue.destroy();
}
with(o_dialogue_optionbutton){
	instance_destroy();
}
for(var i = 0; i < ds_list_size(local_flags); i++){
	flag_remove(local_flags[|i]);
}
ds_list_destroy(local_flags);