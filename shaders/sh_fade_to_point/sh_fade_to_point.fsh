varying vec2 v_vTexcoord;
varying vec4 v_vColour;
// The point at which the fade starts from.
uniform vec2 point;
// Fade factor. Higher means more fade per pixel.
uniform float factor;

void main()
{
	vec4 color = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	float dist = distance(v_vTexcoord, point);
	gl_FragColor = vec4(color.r, color.g, color.b, dist*4.0*factor*color.a);
}
