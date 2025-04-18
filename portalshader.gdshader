shader_type spatial;

uniform float PORTAL_RADIUS = 0.5;
uniform vec3 PORTAL_NORMAL = vec3(0, 0, 1);
uniform vec3 PORTAL_CENTER = vec3(0, 0, 0);
uniform vec3 PORTAL_SEAM = vec3(0, 1, 0);
uniform sampler2D INSIDE_TEXTURE: source_color, repeat_enable;

vec3 perpendicular_part(vec3 direction, vec3 axis) {
    return direction - dot(direction, axis) * axis;
}

vec3 parallel_part(vec3 direction, vec3 axis) {
    return dot(direction, axis) * axis;
}

float angle_between(vec3 vec, vec3 reference) {
    return atan(length(cross(vec, reference)), dot(vec, reference));
}

float signed_angle_between(vec3 vec, vec3 reference, vec3 normal) {
    vec3 cross_to = cross(vec, reference);
	float unsigned_angle = atan(length(cross_to), dot(vec, reference));
	return (dot(cross_to, normal) < 0.) ? unsigned_angle : -unsigned_angle;
}

// Uses a triangle projected onto the plane with points
// - circle center
// - vertex
// - intersection point on the edge of the circle
// and uses the law of sines to compute the relevant distance
vec2 portal_uv(vec3 ray_dir, vec3 ray_start, vec3 portal_center, vec3 portal_normal, vec3 portal_seam, float portal_radius) {
    vec3 lateral_ray = perpendicular_part(ray_dir, portal_normal);
    vec3 lateral_direction = normalize(lateral_ray);
    vec3 initial_offset = ray_start - portal_center;
    vec3 initial_direction = normalize(initial_offset);
    float radius_angle = angle_between(lateral_direction, -initial_direction);
    float sin_ratio = portal_radius / sin(radius_angle);
    float center_angle = asin(length(initial_offset) / sin_ratio);
    float lateral_angle = PI - radius_angle - center_angle;
    float lateral_distance = sin_ratio * sin(lateral_angle);

    vec3 flat_intersection_offset = initial_offset + lateral_distance * lateral_direction;
    float portal_angle = signed_angle_between(normalize(flat_intersection_offset), -portal_seam, portal_normal);
    float depth = abs(dot(ray_dir, portal_normal)) / length(lateral_ray) * lateral_distance;
    return vec2((portal_angle + PI) / TAU, depth);
}

void fragment() {
    vec3 global_view = normalize((INV_VIEW_MATRIX * vec4(VIEW, 0)).xyz);
    vec3 global_vertex = (INV_VIEW_MATRIX * vec4(VERTEX, 1)).xyz;
    if (distance(global_vertex, PORTAL_CENTER) > PORTAL_RADIUS) {
        ALPHA = 0.;
    } else {
        vec2 tube_uv = portal_uv(-global_view, global_vertex, PORTAL_CENTER, PORTAL_NORMAL, PORTAL_SEAM, PORTAL_RADIUS);
        ALBEDO = texture(INSIDE_TEXTURE, tube_uv.xy).rgb;
        ALBEDO.b += tube_uv.y;
        ALPHA = 1.;
    }
}
