shader_type canvas_item;

uniform float time;

void fragment() {
    float noise_value = fract(sin(dot(FRAGCOORD.xy + TIME, vec2(12.9898, 78.233))) * 43758.5453);
    COLOR = vec4(noise_value, noise_value, noise_value, 1.0);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
