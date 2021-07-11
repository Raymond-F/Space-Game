/// @description Insert description here
// You can write your code in this editor
if(PRESSED(ord("1"))){
	dsys_initialize_window("test0.txt");
}
else if(PRESSED(ord("2"))){
	dsys_initialize_window("test1.txt");
}
else if(PRESSED(ord("3"))){
	dsys_initialize_window("test2.txt");
}
else if(PRESSED(vk_f1)){
	var input = get_string("DIALOGUE DEBUGGER: Enter the filename, including .txt, of the dialogue file you want to debug.", "");
	dsys_initialize_window(input);
}
else if(PRESSED(vk_f2)){
	var input = get_string("FLAG SETTER: Enter the name of a flag to set the value of, a space, and then the value to set it to.", "");
	var tokens = string_tokenize(input);
	flag_set(tokens[0], int64(tokens[1]));
}
else if(PRESSED(vk_f3)){
	var input = get_string("FLAG CHECKER: Enter the name of a flag and the value of that flag will be printed to the debug window.", "");
	show_debug_message("Value of flag '" + input + "': " + string(flag_get(input)));
}