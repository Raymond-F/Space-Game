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
	
	int dte = amount+1;
	// Get distance to nearest edge
	for(int i = 1; i <= amount; i++) {
		float f = float(i);
		if (texture2D( gm_BaseTexture, v_vTexcoord + offsetx * f).a == 0.0 ||
			texture2D( gm_BaseTexture, v_vTexcoord - offsetx * f).a == 0.0 ||
			texture2D( gm_BaseTexture, v_vTexcoord + offsety * f).a == 0.0 ||
			texture2D( gm_BaseTexture, v_vTexcoord - offsety * f).a == 0.0) {
		  dte = i;
		  break;
		}
	}
	vec4 color = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	float alpha_mod = float(dte) / (float(amount)+1.0);
    gl_FragColor = vec4(color.r, color.g, color.b, color.a*alpha_mod);
}