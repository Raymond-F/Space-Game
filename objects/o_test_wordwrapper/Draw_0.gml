text_format_draw(10, 10, txt_id, fa_left, fa_top, f_norm);

draw_line(width+20, 0, width+20, room_height)
if mouse_check_button(mb_left)
{
    if mouse_x-10!=width
    {
        text_format_destroy(txt_id)
        width=mouse_x-10
        txt_id=text_format(txt, f_norm, width)
    }   
}

draw_set_valign(fa_top)

