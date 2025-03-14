shader_type sky;

uniform float time;   // Time variable for animation
uniform float speed = 0.02;  // Cloud movement speed
uniform float cloud_density = 0.5; // Adjusts cloud coverage

// Pseudo-random noise function
float rand(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

// Smooth noise function
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(rand(i), rand(i + vec2(1.0, 0.0)), u.x),
               mix(rand(i + vec2(0.0, 1.0)), rand(i + vec2(1.0, 1.0)), u.x), u.y);
}

// Cloud pattern function
float cloud_pattern(vec2 uv, float t) {
    float n = noise(uv * 3.0 + vec2(t * speed, 0.0));
    return smoothstep(cloud_density, cloud_density + 0.1, n);
}

void fragment() {
    vec2 uv = UV;  // Correct UV coordinate for sky shaders
    float clouds = cloud_pattern(uv, time);

    vec3 sky_color = vec3(0.2, 0.5, 1.0);  // Light blue sky
    vec3 cloud_color = vec3(1.0, 1.0, 1.0); // White clouds
    vec3 final_color = mix(sky_color, cloud_color, clouds);

    SKY_COLOR = vec4(final_color, 1.0);
}
