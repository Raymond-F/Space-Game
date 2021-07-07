/// @description  ts_advdraw(x, y, txt, shake, wave, wave_spd, script)
/// @param x
/// @param  y
/// @param  txt
/// @param  shake
/// @param  wave
/// @param  wave_spd
/// @param  script
function ts_advdraw() {

	if global.ts_symb_effects
	{
	    var xx=argument[0], yy=argument[1], txt=argument[2], shake=argument[3], wave=argument[4], wave_spd=argument[5], script=argument[6], w=0, dw=0;
	    for(var i=1; i<=string_length(txt); i++)
	    {
	        ts_current_symb=string_char_at(txt, i)
	        ts_current_x=xx+w;
	        ts_current_y=yy;
	        if wave_spd!=0 
	            ts_current_y+=cos(current_time*0.001*wave_spd+ts_current_x*0.007*wave_spd)*wave
	        ts_current_x+=irandom_range(-shake, shake)
	        ts_current_y+=irandom_range(-shake, shake)
        
	        for(var j=0; j<15; j++)
	            if script[j]>=0
	                script_execute(script[j], ts_current_x, ts_current_y, ts_current_symb)
	        if script[15]>=0 
	            var dw=script_execute(script[15], ts_current_x, ts_current_y, ts_current_symb);
	        else
	            draw_text(ts_current_x, ts_current_y, string_hash_to_newline(ts_current_symb))
	        for(var j=16; j<31; j++)
	            if script[j]>=0
	                script_execute(script[j], ts_current_x, ts_current_y, ts_current_symb)
            
	        if dw=0 w+=string_width(string_hash_to_newline(ts_current_symb)) else w+=dw
	    }
	}
	else
	    draw_text(argument[0], argument[1], string_hash_to_newline(argument[2]))



}
