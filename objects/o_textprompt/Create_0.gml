/// @description Insert description here
// You can write your code in this editor
previous_layer = global.ui_layer;
global.ui_layer = 1;
depth = -100;

top_text = "";
tip_text = "";

confirmed = false;

on_close = function() {
	/*
		This function will hold the function of whatever this prompt does when it has text entered.
		Generall, cancel will do nothing and confirm will set a text field somewhere.
	*/
}

continue_button = instance_create(x + 330, y + sprite_height - 56, o_button);
continue_button.sprite_index = s_button_medium;
continue_button.text = "CONFIRM";
continue_button.on_press = function() {
	with(o_textprompt) {
		confirmed = true;
		instance_destroy();
	}
}
continue_button.ui_layer = 1;
continue_button.depth = depth - 1;
continue_button.press_sound = snd_interface_pressbutton1;

cancel_button = instance_create(x + 430, y + sprite_height - 56, o_button);
cancel_button.sprite_index = s_button_medium;
cancel_button.text = "CANCEL";
cancel_button.on_press = function() {
	with(o_textprompt) {
		confirmed = false;
		instance_destroy();
	}
}
cancel_button.ui_layer = 1;
cancel_button.depth = depth - 1;
cancel_button.press_sound = snd_interface_pressbutton1;

contents = "";
keyboard_lastchar = "";