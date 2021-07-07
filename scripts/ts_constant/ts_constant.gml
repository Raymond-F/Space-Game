/// @description  ts_constant(name, value)
/// @param name
/// @param  value
function ts_constant(argument0, argument1) {
	global.ts_varmap[? argument0]=string(argument1)

	/*

	use it in usertags us arguments, ex:
	    ts_constant('coin', s_coin)
	    txt='you have 200<img:coin|>', coin will be change to index of sprite "s_coin"


/* end ts_constant */
}
