/// text_format_draw(x, y, text_formatted, halign, valign, font[, count])
function text_format_draw() {

	var count=-1, xx=argument[0], yy=argument[1], text_f=argument[2], halign=argument[3], valign=argument[4], font=argument[5], startcolor=draw_get_colour();
	if argument_count>=7
	    count=argument[6];

	var qt=text_f[| 2], W=text_f[| 0], H=text_f[| 1], hlgn=0, vlgn=1, line=0, line_c=0, line_h=0, link="", link_c=0, link_press=0,
	    shadow=0, shadow_c=0, shadow_a=0, shadow_x=0, shadow_y=0, wave=0, wave_spd=0, shake=0, script, glow=-1;
    
	    for(var i=0; i<31; i++)
	        script[i]=-1

	var q=ds_queue_create();
	ds_queue_copy(q, qt)

	switch halign
	{
	    case fa_center: xx-=0.5*W; break
	    case fa_right:  xx-=W;   break
	}

	draw_set_font(font)
	draw_set_valign(fa_top)
	draw_set_halign(fa_left)

	var gx, gy, outline=0;

	while !ds_queue_empty(q)
	{
	    var tH=ds_queue_dequeue(q),
	        mh=ds_queue_dequeue(q),
	        mw=ds_queue_dequeue(q),
	        vlgn=ds_queue_dequeue(q),
	        hlgn=ds_queue_dequeue(q),
	        na=ds_queue_dequeue(q),
	        elements=ds_queue_dequeue(q),
	        justify=ds_queue_dequeue(q);
    
	    switch valign
	    {
	        case fa_top:    gy=yy+tH; break
	        case fa_center: gy=yy+tH-H*0.5; break
	        case fa_bottom: gy=yy+tH-H; break
	    }
	    gx=xx+(W-mw)*hlgn
	    switch vlgn
	    {
	        case 0:   draw_set_valign(fa_top);                break
	        case 0.5: draw_set_valign(fa_center); gy+=mh*0.5; break
	        case 1:   draw_set_valign(fa_bottom); gy+=mh;     break
	    }
    
	    /*if keyboard_check_pressed(vk_space)
	    {
	        show_debug_message(na)
	        show_debug_message(justify)
	        show_debug_message(elements)
	    }*/
    
	    for(var i=0; i<array_length_1d(na); i++)
	    {
	        var token=na[i];
	        if is_real(token)
	        {
	            if count=0 break
	            i++
	            if token=ts.shake
	            {
	                shake=na[i]; 
	            }
	            else
	            if token=ts.glow
	            {
	                glow=na[i]; 
	            }
	            else
	            if token=ts.wave
	            {
	                wave_spd=na[i]; i++
	                wave=na[i]
	            }
	            else
	            if token=ts.script
	            {
	                var scriptind=na[i]; i++
	                script[real(scriptind)]=na[i]; 
	            }
	            else
	            if token=ts.outline
	            {
	                outline=na[i]; i++
	                outline_c=na[i]; i++
	                outline_w=na[i]
	            }
	            else
	            if token=ts.unline
	            {
	                line_h=na[i]; i++
	                line_c=na[i]
	                line=(line_h!=0)
	            }
	            else
	            if token=ts.link
	            {
	                link=na[i]; i++
	                link_c=na[i]; i++
	                link_press=na[i]
                
	                if string_digits(link)==link and string_length(link) > 0
	                    link=real(link)
	            }
	            else
	            if token=ts.shadow
	            {
	                shadow=na[i]; i++
	                shadow_c=na[i]; i++
	                shadow_a=na[i]; i++
	                shadow_x=na[i]; i++
	                shadow_y=na[i]
                
	                if string_digits(link)=link and string_length(link) > 0
	                    link=real(link)
	            }
	            else
	            if token=ts.colour
	            {
	                draw_set_colour(na[i])
	            }
	            else
	            if token=ts.font
	            {
	                draw_set_font(na[i])
	            }
	            else
	            if token=ts.space
	            {
	                gx+=na[i]
	            }
	            else
	            if token=ts.image
	            {
	                if count>0
	                    count-=1
                
                
	                spr=na[i]; i++
	                type=na[i]; i++
	                w=na[i]; i++
	                h=na[i]; i++
	                X=na[i]; i++
	                Y=na[i]; i++
	                xscale=na[i]; i++
	                yscale=na[i]
                
	                if type=ts.in
	                    draw_sprite_ext(spr, -1, gx, gy-vlgn*h, xscale, yscale, 0, c_white, 1)
	                else if type=ts.out
	                {
	                    draw_sprite_part_ext(spr, -1, (sprite_get_width(spr)-w/xscale)*0.5, (sprite_get_height(spr)-h/yscale)*0.5, w/xscale, h/yscale, gx, gy-vlgn*h, xscale, yscale, c_white, 1)
	                }
	                else if type=ts.part
	                    draw_sprite_part(spr, -1, X, Y, w, h, gx, gy-vlgn*h)
                
	                gx+=w
	                if justify and global.ts_j and elements>=2 gx+=(W-mw)/(elements-1)
	            }
	        }
	        else
	        if token!=""
	        {
	            var clen=string_length(token);
	            if count!=-1
	            if clen>=count
	            {
	                token=string_copy(token, 1, count)
	                count=0
	            }
	            else
	                count-=clen
            
	            var text_x0=gx, text_y0=gy-string_height(token)*vlgn, 
	                text_x1=text_x0+string_width(token), text_y1=text_y0+string_height(token);
            
	            var tgx=round(gx),
	                tgy=round(gy);
                
	            if glow>=0
	                draw_rectangle_colour(text_x0, text_y0, text_x1, text_y1, glow, glow, glow, glow, 0)
            
	            if outline
	            {
	                var prec=draw_get_colour();
	                draw_set_colour(outline_c)
                
	                ts_advdraw(tgx+outline_w, tgy, token, shake, wave, wave_spd, script)
	                ts_advdraw(tgx-outline_w, tgy, token, shake, wave, wave_spd, script)
	                ts_advdraw(tgx, tgy+outline_w, token, shake, wave, wave_spd, script)
	                ts_advdraw(tgx, tgy-outline_w, token, shake, wave, wave_spd, script)
                
	                draw_set_colour(prec)
	            }
            
	            if link!=""
	            {
	                var precl=draw_get_colour();
	                if point_in_rectangle(mouse_x, mouse_y, text_x0, text_y0, text_x1, text_y1)
	                {
	                    if link_c!=ts.standart draw_set_colour(link_c)
	                    if mouse_check_button(mb_left) and link_press!=ts.standart
	                        draw_set_colour(link_press)
	                    if mouse_check_button_released(mb_left)
	                        if is_real(link)
	                            script_execute(link)
	                        else
	                            url_open(link)
	                }
	            }
            
	            if shadow
	            {
	                var prec=draw_get_colour(), prea=draw_get_alpha();
	                if shadow_c!=-1 draw_set_colour(shadow_c)
	                if shadow_a!=-1 draw_set_alpha(shadow_a)
	                ts_advdraw(tgx+shadow_x, tgy+shadow_y, token, shake, wave, wave_spd, script)
	                draw_set_colour(prec)
	                draw_set_alpha(prea)
	            }
            
	            ts_advdraw(tgx, tgy, token, shake, wave, wave_spd, script)
            
	            if line
	            {
	                var prec=draw_get_colour();
	                if line_c!=-1 draw_set_colour(line_c)
	                draw_line_width(text_x0, text_y1, text_x1, text_y1, line_h)
	                draw_set_colour(prec)
	            }
	            if link!=""
	                draw_set_colour(precl)
                
	            gx+=string_width(token)
	            if justify and global.ts_j and elements>=2 gx+=(W-mw)/(elements-1)
	        }
	    }
	    na=0
    
	}
	ds_queue_destroy(q)

	draw_set_colour(startcolor)
	return count>0



}
