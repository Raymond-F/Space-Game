varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float pixelH;
uniform float pixelW;
uniform float draw_alpha;
uniform float colors[3];

void main()
{
	vec2 offsetx;
	offsetx.x = pixelW;
	vec2 offsety;
	offsety.y = pixelH;

	float alpha = texture2D( gm_BaseTexture, v_vTexcoord ).a;
	alpha += ceil(texture2D( gm_BaseTexture, v_vTexcoord + offsetx ).a);
	alpha += ceil(texture2D( gm_BaseTexture, v_vTexcoord + offsety ).a);
	alpha += ceil(texture2D( gm_BaseTexture, v_vTexcoord - offsetx ).a);
	alpha += ceil(texture2D( gm_BaseTexture, v_vTexcoord - offsety ).a);
	
    gl_FragColor = vec4(colors[0],colors[1],colors[2],alpha*draw_alpha);
}