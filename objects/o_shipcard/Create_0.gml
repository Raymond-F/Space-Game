/// @description Insert description here
// You can write your code in this editor
par = noone;
pos = -1; // position in module list this corresponds to
name = "";
sprite = s_cargo_placeholder;
y_cutoff = [99999, 0]; // Point at which this card becomes inactive: [> top, <bottom]
active = true;
prompt = noone;
struct = noone;

tooltip_delay = 30;
tooltip_timer = tooltip_delay;
mouse_xprevious = mouse_x;
mouse_yprevious = mouse_y;

swap_button = instance_create(x + sprite_width - sprite_get_width(s_button_small) - 8, y + sprite_height - sprite_get_height(s_button_small) - 8, o_button);
swap_button.sprite_index = s_button_small;
swap_button.sprite = s_icon_equipship;
swap_button.on_press = function() {
	var temp = global.editing_ship;
	global.editing_ship = struct;
	struct = temp;
	global.player_ship_inventory[|pos] = struct;
	with (o_manage_ship_pane) {
		refresh();
	}
}
swap_button.depth = depth-1;
swap_button.press_sound = snd_interface_install;

name_button = instance_create(x + sprite_width - sprite_get_width(s_button_small) - 8, y + sprite_height - sprite_get_height(s_button_small)*2 - 16, o_button);
name_button.sprite_index = s_button_small;
name_button.sprite = s_icon_nameship;
name_button.on_press = function() {
	prompt = instance_create(GUIW/2 - sprite_get_width(s_prompt_textbox)/2, GUIH/2 - sprite_get_height(s_prompt_textbox)/2, o_textprompt);
	prompt.top_text = "NAME SHIP";
	prompt.tip_text = "Enter the desired nickname for this ship below.";
	prompt.on_close = function() {
		if(struct != noone && prompt.confirmed && prompt.contents != "") {
			struct.nickname = prompt.contents;
		}
		prompt = noone;
	}
}
name_button.depth = depth-1;
name_button.press_sound = snd_interface_pressbutton1;