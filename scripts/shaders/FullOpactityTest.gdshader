shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	vec3 texCol = texture(TEXTURE, UV).rgb;
	
	COLOR.rgb = texCol;
	
	COLOR.a = 0.5;
}
