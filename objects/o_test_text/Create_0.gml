ts_init()
ts_add_keyword("[-#-]", ts_halign(fa_center))
ts_add_keyword("[#--]", ts_halign(fa_left))
ts_add_keyword("[--#]", ts_halign(fa_right))
ts_add_keyword("[/]", ts_line())
ts_add_keyword("[//]", ts_lineback())
ts_add_keyword("[white]", ts_colour(c_white))
ts_add_keyword("[red]", ts_colour(c_red))
ts_add_keyword("<outl>", ts_outline(1, c_red))
ts_add_keyword("</outl>", ts_outline(0))
ts_add_keyword("[big]", ts_font(f_big))
ts_add_keyword("[bold]", ts_font(f_norm_bold))
ts_add_keyword("[norm]", ts_font(f_norm))
ts_add_keyword("[earth]", ts_image(s_world))
ts_add_keyword("[coin]", ts_image(s_coin))
ts_add_keyword("/s", ts_space(110))


txt=
    "[-#-][big]Hello, it is [red]TEXT[white][/]"+
    "[#--][norm]In <outl>literary</outl> theory, a text is any object that can be \"[bold]read[norm]\". "+
    "I know, that we live on planet: [earth] and we can fly to space(if you have[coin])[/]"+
    "[-#-][big][red]END[/][white]"+
    "[#--]Look at this table:[/][norm]"+
    "money[//]/s 10[coin][//]/s/s OK[/]"+
    "score[//]/s 175[//]/s/s [red]ERROR[white][/]"+
    "This text is "+ts_underline(2, c_white)+"important"+ts_underline()+"!"
    
txt_id=text_create(txt, f_norm, 400)
count=0


