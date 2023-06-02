shader_type canvas_item;

uniform vec2 deformation = vec2(0, 0);
uniform float sideWaysDeformationFactor = 5.0f;

void fragment() {
	vec2 deformationStrength = abs(deformation);
	float sideWaysDeformation = min(deformationStrength.x, deformationStrength.y);
	float spriteWidth = abs(VERTEX.x);
	if (sign(VERTEX.y) != sign(deformation.y)) {
		VERTEX.x += sideWaysDeformation * sideWaysDeformationFactor * spriteWidth * sign(deformation.x);
	}
	COLOR = vec4(0, 0, 0, 0);
}
