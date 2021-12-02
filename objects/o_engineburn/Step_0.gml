/// @description Insert description here
// You can write your code in this editor
count--;
if(count <= 0) {
	count = 4;
	image_xscale = choose(-1, 1) * base_scale;
	var chosen_index;
	do {
		chosen_index = irandom(image_number);
	} until (chosen_index != image_index);
	image_index = chosen_index;
	image_yscale = random_range(0.9, 1.1) * base_scale;
}
depth = par.depth+1;