shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform vec2 target = vec2(-1.1);
uniform float intensity : hint_range(0.0f, 1.0f);

void fragment() {
	COLOR.rgba = texture(SCREEN_TEXTURE, SCREEN_UV, 6.0f * intensity * (distance(target, UV)/sqrt(2))).rgba;
}