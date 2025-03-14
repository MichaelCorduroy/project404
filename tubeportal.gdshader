shader_type spatial;

uniform float speed = 1.5;
uniform float wave_intensity = 0.2;

void fragment() {
    vec2 uv = UV;
    
    // Create a spiral effect
    float angle = atan(uv.y - 0.5, uv.x - 0.5);
    float radius = length(uv - vec2(0.5));

    float waves = sin((angle * 10.0) + (TIME * speed)) * wave_intensity;
    float pattern = fract(radius * 10.0 + waves);

    // Purple color scheme
    vec3 color1 = vec3(0.6, 0.1, 0.9);  // Light purple
    vec3 color2 = vec3(0.2, 0.0, 0.4);  // Dark purple

    ALBEDO = mix(color1, color2, step(0.5, pattern));
}


//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
