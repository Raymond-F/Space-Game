/// @description Insert description here
// You can write your code in this editor
if(PRESSED(vk_anykey)) {
	if (keyboard_lastkey == vk_backspace) {
		contents = string_copy(contents, 0, max(0, string_length(contents)-1));
	} else if (keyboard_lastkey == vk_enter) {
		continue_button.on_press();
	} else if (keyboard_lastkey == vk_escape) {
		cancel_button.on_press();
	} else {
		contents += keyboard_lastchar;
	}
	io_clear();
	keyboard_lastchar = "";
}