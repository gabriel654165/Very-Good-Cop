shader_type canvas_item;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform vec4 color : source_color;

uniform float amplitude : hint_range(0.0, 0.15);
uniform float period;
uniform float phaseShift;
uniform float upperLimit : hint_range(0.0, 10.0);

void fragment() {
	vec2 modifiedUV = SCREEN_UV;
	
	modifiedUV.x -= (((1.0 - modifiedUV.y) * amplitude) *
		sin(period * (modifiedUV.y - (TIME * 0.016 * phaseShift)))) * 
		clamp(1.0 - (modifiedUV.y * (10.0 - upperLimit)), 0.0, 0.5);
	
	COLOR = texture(SCREEN_TEXTURE, modifiedUV);
	COLOR.rgb += color.rgb * color.a;
}
