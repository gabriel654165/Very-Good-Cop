shader_type canvas_item;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float temperatureRange : hint_range(-1.0, 1.0);
uniform vec4 hotColor : source_color;

uniform float heatAmplitude : hint_range(0.0, 0.15);
uniform float heatPeriod;
uniform float heatPhaseShift;
uniform float heatUpperLimit : hint_range(0.0, 10.0);

void fragment() {
	float currentHot = clamp(temperatureRange, 0.0, 1.0);
	float currentCold = -clamp(temperatureRange, -1.0, 0.0);
	vec4 hotnessColor = (hotColor * currentHot);
	vec2 modifiedUVHot = SCREEN_UV;
	
	modifiedUVHot.x -= 
		(
			((1.0 - modifiedUVHot.y) * heatAmplitude) *
			sin(heatPeriod * (modifiedUVHot.y - (TIME * 0.016 * heatPhaseShift)))
		) * 
			clamp(1.0 - (modifiedUVHot.y * (10.0 - heatUpperLimit)), 0.0, 0.5
		) * 
			currentHot;
	
	COLOR = texture(SCREEN_TEXTURE, modifiedUVHot);
	COLOR.rgb += hotnessColor.rgb * hotnessColor.a;
}
