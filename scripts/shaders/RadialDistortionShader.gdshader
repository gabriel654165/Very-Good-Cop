shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float aspect = 1.0;
uniform float distortion = 1.0;
uniform float radius = 1.0;
uniform float alpha = 1.0;

vec2 distort(vec2 p)
{
	float d = length(p);
	float z = sqrt(distortion + d * d * -distortion);
	float r = atan(d, z) / 3.1415926535;
	float phi = atan(p.y, p.x);
	return vec2(r * cos(phi) * (1.0 / aspect) + 0.5, r * sin(phi) + 0.5);
}

void fragment()
{
	// move origin of UV coordinates to center of screen
	vec2 xy = (SCREEN_UV * 2.0 - 1.0);
	// adjust aspect ratio
	xy = vec2(xy.x * aspect, xy.y * aspect);
	// distance from center
	float d = length(xy);

	if (d < radius) {
		xy = distort(xy);
		COLOR.rgb = texture(SCREEN_TEXTURE, xy).rgb;
		COLOR.a = alpha;
	}
}
