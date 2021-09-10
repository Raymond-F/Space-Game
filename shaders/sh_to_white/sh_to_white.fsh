//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float draw_alpha;

void main()
{
    gl_FragColor = vec4(1.0,1.0,1.0,draw_alpha * texture2D(gm_BaseTexture, v_vTexcoord).a);
}