varying vec2 v_vTexcoord;
varying vec4 v_vColour;
// The point at which the fade starts from.
uniform vec2 point;
// Fade factor. Higher means more fade per pixel.
uniform float factor;
// Buffer. How much before face starts
uniform float buffer;

void main()
{
	vec4 color = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	float dist = max(0.0, distance(v_vTexcoord, point) - buffer);
	gl_FragColor = vec4(color.r, color.g, color.b, (1.0 - dist*4.0*factor) * color.a);
}
