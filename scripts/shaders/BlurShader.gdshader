shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform bool has_target = false;
uniform vec2 target = vec2(0.5,0.5);
uniform float intensity : hint_range(0.1f, 4.0f) = 1.0;

void fragment() {
	if (has_target) {
		COLOR.rgba = texture(SCREEN_TEXTURE, SCREEN_UV, 7.0 * intensity * (distance(target, UV)/sqrt(2))).rgba;
	} else {
		COLOR.rgba = texture(SCREEN_TEXTURE, SCREEN_UV, intensity).rgba;
	}
}
