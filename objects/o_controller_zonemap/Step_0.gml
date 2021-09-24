/// @description Insert description here
// You can write your code in this editor
selected_hex = mouse_get_hex();

if (MPRESSED(mb_right) && selected_hex != noone) {
	targeted_hex = selected_hex;
	set_player_dest();
	targeted_hex = noone;
}
else if (MPRESSED(mb_left)) {
	if (selected_hex != noone) {
		if (selected_hex == targeted_hex) {
			set_player_dest();
			targeted_hex = noone;
		} else {
			targeted_hex = selected_hex;
		}
	}
}