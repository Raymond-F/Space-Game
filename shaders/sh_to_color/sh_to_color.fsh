//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float colors[3];
uniform float draw_alpha;

void main()
{
    gl_FragColor = vec4(colors[0],colors[1],colors[2],draw_alpha * texture2D(gm_BaseTexture, v_vTexcoord).a);
}