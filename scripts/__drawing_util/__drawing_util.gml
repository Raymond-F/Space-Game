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