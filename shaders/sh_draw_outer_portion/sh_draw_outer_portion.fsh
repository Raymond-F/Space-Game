varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float pixelH;
uniform float pixelW;
// Amount to feather in pixels.
uniform int amount;

void main()
{
	vec2 offsetx;
	offsetx.x = pixelW;
	vec2 offsety;
	offsety.y = pixelH;
	
	int alpha_mod = 0;
	// Get distance to nearest edge
	for(int i = 1; i <= amount; i++) {
		float f = float(i);
		if (texture2D( gm_BaseTexture, v_vTexcoord + offsetx * f).a == 0.0 ||
			texture2D( gm_BaseTexture, v_vTexcoord - offsetx * f).a == 0.0 ||
			texture2D( gm_BaseTexture, v_vTexcoord + offsety * f).a == 0.0 ||
			texture2D( gm_BaseTexture, v_vTexcoord - offsety * f).a == 0.0) {
		  alpha_mod = 1;
		  break;
		}
	}
	vec4 color = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
    gl_FragColor = vec4(color.r, color.g, color.b, color.a*float(alpha_mod));
}