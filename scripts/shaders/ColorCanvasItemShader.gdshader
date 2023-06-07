shader_type canvas_item;

uniform vec4 color : source_color;

void fragment() {
	// if it's a ColorRect it will apply the right color
	if (COLOR.r >= 1. && COLOR.g >= 1. && COLOR.b >= 1.) {
		COLOR = color;
	// else it will keep the shape of the texture
	} else {
		COLOR.rgb += color.rgb * color.a;
		COLOR.a -= color.a;
	}
	if (color.a == 0.) {
		COLOR.a = 0.;
	}
}
