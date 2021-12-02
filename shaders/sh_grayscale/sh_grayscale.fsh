//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
//uniform float draw_alpha = 1.0;

void main()
{
	float avg = (texture2D(gm_BaseTexture, v_vTexcoord).r +
			     texture2D(gm_BaseTexture, v_vTexcoord).g +
				 texture2D(gm_BaseTexture, v_vTexcoord).b) / 3.0;
    gl_FragColor = vec4(avg, avg, avg, texture2D(gm_BaseTexture, v_vTexcoord).a);
}