// Utility functions related to drawing to the screen
function color_interpolate(c1, c2, amount) {
	var r1 = (c1 & c_red);
	var r2 = (c2 & c_red);
	var g1 = (c1 & c_lime) >> 8;
	var g2 = (c2 & c_lime) >> 8;
	var b1 = (c1 & c_blue) >> 16;
	var b2 = (c2 & c_blue) >> 16;

	var blue = round(lerp(b1,b2,amount));
	var green = round(lerp(g1,g2,amount));
	var red = round(lerp(r1,r2,amount));
	return (blue << 16) + (green << 8) + red;
}

function draw_progress_bar(x1, y1, x2, y2, border_width, fill_color, border_color, current_val, target_val, inverted = false) {
	var pcolor = draw_get_color();
	if(abs(y2 - y1) <= (border_width+1)*2 + 1 || abs(x2 - x1) <= (border_width+1)*2 + 1) {
		return;
	}
	if(border_width < 0) border_width = 0;
	if(x1 > x2) {
		var t = x1;
		x1 = x2;
		x2 = t;
	}
	if(y1 > y2) {
		var t = y1;
		y1 = y2;
		y2 = t;
	}
	var pct = clamp(current_val/target_val, 0, 1);
	draw_set_color(border_color);
	var xs = x1, xe = x2, ys = y1, ye = y2;
	repeat(border_width) {
		draw_rectangle(xs, ys, xe, ye, true);
		xs++;
		xe--;
		ys++;
		ye--;
	}
	xs++;
	xe--;
	ys++;
	ye--;
	var bar_width = xe - xs;
	var filled_length = round(bar_width * pct);
	if (pct > 0) {
		draw_set_color(fill_color);
		if (inverted) {
			draw_rectangle(xe, ys, xe - filled_length, ye, false);
		} else {
			draw_rectangle(xs, ys, xs + filled_length, ye, false);
		}
	}
	draw_set_color(pcolor);
}

// Clear thee buffer of a surface, so it doesn't artifact
function surface_clear(surface_id) {
	var pcolor = draw_get_color();
	var pbm = gpu_get_blendmode();
	var pa = draw_get_alpha();
	draw_set_color(c_white);
	gpu_set_blendmode(bm_subtract);
	surface_set_target(surface_id);
	draw_set_alpha(1);
	draw_rectangle(0, 0, surface_get_width(surface_id), surface_get_height(surface_id), false);
	surface_reset_target();
	gpu_set_blendmode(pbm);
	draw_set_color(pcolor);
	draw_set_alpha(pa);
}

// Draw an arc with center [cx, cy], on the interval [degree_start, degree_end], with width
// `outer` - `inner`.
// Draws counter-clockwise.
function draw_arc(cx, cy, degree_start, degree_end, outer, inner, color = draw_get_color()) {
	if (outer - inner <= 0) {
		return;
	}
	
	var surf = surface_create(outer * 2, outer * 2);
	surface_set_target(surf);
	var pcolor = draw_get_color();
	draw_set_color(color);
	// Draw the primary constituent circle
	draw_circle(outer, outer, outer, false);
	draw_set_color(c_white);
	gpu_set_blendmode(bm_subtract);
	draw_circle(outer, outer, inner, false);
	gpu_set_blendmode(bm_normal);
	
	if (degree_start > degree_end) {
		var t = degree_start;
		degree_start = degree_end;
		degree_end = t;
	}
	// Chunk out pieces, 45 degrees at a time
	var dif = degree_end - degree_start;
	var cur = degree_start;
	var surf2 = surface_create(surface_get_width(surf), surface_get_height(surf));
	surface_reset_target();
	surface_set_target(surf2);
	while (dif > 0) {
		var width = min(45, dif);
		dif -= width;
		draw_triangle(outer, outer, outer + lengthdir_x(outer*1.5, cur), outer + lengthdir_y(outer*1.5, cur),
			outer + lengthdir_x(outer*1.5, cur+width), outer + lengthdir_y(outer*1.5, cur+width), false);
		cur += width;
	}
	surface_reset_target();
	// Subtract the chunks from a copy of the main ring
	var surf3 = surface_create(surface_get_width(surf), surface_get_height(surf));
	surface_set_target(surf3);
	draw_surface(surf, 0, 0);
	gpu_set_blendmode(bm_subtract);
	draw_surface(surf2, 0, 0);
	surface_reset_target();
	// Subtract the "negative" surface from the original
	surface_set_target(surf);
	draw_surface(surf3, 0, 0);
	gpu_set_blendmode(bm_normal);	
	
	surface_reset_target();
	draw_surface(surf, cx - outer, cy - outer);
	surface_clear(surf);
	surface_clear(surf2);
	surface_clear(surf3);
	surface_free(surf);
	surface_free(surf2);
	surface_free(surf3);
	draw_set_color(pcolor);
}

// Draw a tooltip box in the given coordinates
// Constraints: x1 < x2 & y1 < y2
function tooltip_draw_background(x1, y1, x2, y2) {
	var pcolor = draw_get_color();
	
	draw_set_color(C_WINDOW_BACKGROUND);
	draw_rectangle(x1, y1, x2, y2, false);
	draw_set_color(C_WINDOW_HIGHLIGHT);
	draw_rectangle(x1+1, y1+1, x2-1, y2-1, true);
	draw_set_color(C_WINDOW_BORDER);
	draw_rectangle(x1, y1, x2, y2, true);
	draw_rectangle(x1+2, y1+2, x2-2, y2-2, true);
	
	draw_set_color(pcolor);
}

// Draw a basic tooltip to the screen
function draw_tooltip(_x, _y, _name_text, _tip_text) {
	var sx = _x;
	var sy = _y;
	var name_text = string_upper(_name_text);
	var tip_text = _tip_text;
	var border = 6;
	draw_set_font(fnt_dialogue);
	var ttw = string_width_ext(tip_text, -1, 300);
	var tth = string_height_ext(tip_text, -1, 300);
	draw_set_font(fnt_dialogue_big);
	var namew = string_width_ext(name_text, -1, 300);
	var nameh = string_height_ext(name_text, -1, 300);
	var twidth = max(namew, ttw);
	var theight = nameh + border + tth;
	tooltip_draw_background(sx, sy, sx + border*2 + twidth, sy + border*2 + theight);
	draw_set_color(C_DIALOGUE);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_text_ext(sx+border, sy+border, name_text, -1, namew);
	draw_set_font(fnt_dialogue);
	draw_text_ext(sx+border, sy+border*2+nameh, tip_text, -1, ttw);
}

// Draw a tooltip for an item in inventory to the screen
function draw_tooltip_item(_x, _y) {
	var sx = _x;
	var sy = _y;
	var name_text = string_upper(name);
	var tip_text = "";
	if(ds_map_exists(global.item_tooltips, name)) {
		tip_text = global.item_tooltips[? name];
	}
	var border = 6;
	draw_set_font(fnt_dialogue);
	var ttw = string_width_ext(tip_text, -1, 300);
	var tth = string_height_ext(tip_text, -1, 300);
	draw_set_font(fnt_dialogue_big);
	var namew = string_width_ext(name_text, -1, 300);
	var nameh = string_height_ext(name_text, -1, 300);
	var twidth = max(namew, ttw);
	var theight = nameh + border + tth;
	tooltip_draw_background(sx, sy, sx + border*2 + twidth, sy + border*2 + theight);
	draw_set_color(C_DIALOGUE);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_text_ext(sx+border, sy+border, name_text, -1, namew);
	draw_set_font(fnt_dialogue);
	draw_text_ext(sx+border, sy+border*2+nameh, tip_text, -1, ttw);
	draw_set_halign(fa_right);
	var value = item_get_true_value(struct);
	var value_string = string(value);
	if (variable_struct_exists(struct, "tags") && struct.has_tag("trade")) {
		value_string += "(T)";
	}
	var vwidth = string_width(value_string);
	draw_text(sx + twidth + 2, sy + border - 2, value_string);
	draw_sprite(s_icon_pix, 0, sx + twidth - vwidth - sprite_get_width(s_icon_pix) + 6, sy + border - 2);
}

function draw_rectangle_feathered(x1, y1, x2, y2, base_alpha, amount) {
	var pa = draw_get_alpha();
	var a = base_alpha;
	for (var i = 0; i < amount; i++) {
		draw_set_alpha(a);
		draw_rectangle(x1 + i, y1 + i, x2 - i, y2 - i, true);
		a -= base_alpha/amount;
	}
	draw_set_alpha(pa);
}

function draw_outline(spr, img_index, xx, yy, xscale, yscale, rot, alpha, col_array = [0, 0, 0]) {
	var tex = sprite_get_texture(spr, img_index);
	var pW = texture_get_texel_width(tex);
	var pH = texture_get_texel_height(tex);
	shader_set(sh_outline_only);
	var u_pW = shader_get_uniform(sh_outline_only, "pixelW");
	var u_pH = shader_get_uniform(sh_outline_only, "pixelH");
	var u_alpha = shader_get_uniform(sh_outline_only, "draw_alpha");
	var u_col = shader_get_uniform(sh_outline_only, "colors");
	shader_set_uniform_f(u_pW, pW);
	shader_set_uniform_f(u_pH, pH);
	shader_set_uniform_f(u_alpha, alpha);
	shader_set_uniform_f_array(u_col, col_array);
	draw_sprite_ext(spr, img_index, xx, yy, xscale, yscale, rot, c_white, alpha);
	shader_reset();
}

function draw_outline_surface(surf, xx, yy, alpha, col_array = [0, 0, 0]) {
	var tex = surface_get_texture(surf);
	var pW = texture_get_texel_width(tex);
	var pH = texture_get_texel_height(tex);
	shader_set(sh_outline_only);
	var u_pW = shader_get_uniform(sh_outline_only, "pixelW");
	var u_pH = shader_get_uniform(sh_outline_only, "pixelH");
	var u_alpha = shader_get_uniform(sh_outline_only, "draw_alpha");
	var u_col = shader_get_uniform(sh_outline_only, "colors");
	shader_set_uniform_f(u_pW, pW);
	shader_set_uniform_f(u_pH, pH);
	shader_set_uniform_f(u_alpha, alpha);
	shader_set_uniform_f_array(u_col, col_array);
	draw_surface(surf, xx, yy);
	shader_reset();
}

function draw_with_outline(spr, img_index, xx, yy, xscale, yscale, rot, alpha, col_array = [0, 0, 0]) {
	draw_sprite_ext(spr, img_index, xx, yy, xscale, yscale, rot, c_white, alpha);
	draw_outline(spr, img_index, xx, yy, xscale, yscale, rot, alpha, col_array);
}