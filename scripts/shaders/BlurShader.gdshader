shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform vec2 target = vec2(-1.1);
uniform float intensity : hint_range(0.0f, 10.0f);
uniform float focusSize : hint_range(1.0, 10.0);

void fragment() {
	COLOR.rgba = texture(SCREEN_TEXTURE, SCREEN_UV, focusSize * intensity * (distance(target, UV)/sqrt(2))).rgba;
}