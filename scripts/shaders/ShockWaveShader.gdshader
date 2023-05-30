shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform vec2 center = vec2(0.6, 0.6);
uniform float force;
uniform float size;
uniform float thickness;

void fragment() {
	float ratio = TEXTURE_PIXEL_SIZE.x / TEXTURE_PIXEL_SIZE.y;
	vec2 scaleUV = (UV - vec2(0.5, 0.0) ) / vec2(ratio, 1.0) + vec2(0.5, 0.0);
	float mask = (1.0 - smoothstep(size-0.1, size, length(scaleUV - center))) * 
		smoothstep(size-thickness-0.1, size-thickness, length(scaleUV - center));
	//float mask = (1.0 - smoothstep(size-thickness, size, length(scaleUV - center))) * 
	//	smoothstep(size-thickness-0.1, size-thickness, length(scaleUV - center));
	vec2 disp = normalize(scaleUV- center) * force * mask;
	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV - disp);
	//COLOR.rgb = vec3(mask);
}
