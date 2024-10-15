shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_lambert, specular_schlick_ggx;


// Varyings
varying vec2 pupil_uv_left;
varying vec2 eye_uv_right;
varying vec2 pupil_uv_right;
varying vec2 mouth_uv;

group_uniforms textures;
uniform sampler2D base_texture : source_color, filter_nearest, repeat_disable;
uniform sampler2D eye_texture : source_color, filter_nearest, repeat_disable;
uniform sampler2D pupil_texture : source_color, filter_nearest, repeat_disable;
uniform sampler2D mouth_texture : source_color, filter_nearest, repeat_disable;

group_uniforms pupil_control;
uniform vec4 pupil_transform_right = vec4(0.0, 0.0, 1.0, 0.0);
uniform vec4 pupil_transform_left = vec4(0.0, 0.0, 1.0, 0.0);

// All components are in the range [0…1], including hue.
vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

// All components are in the range [0…1], including hue.
vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void vertex() {
	// Called for every vertex the material is visible on.
	pupil_uv_left = CUSTOM0.xy;
	eye_uv_right = CUSTOM0.zw;
	pupil_uv_right = CUSTOM1.xy;
	mouth_uv = CUSTOM1.zw;
}

float eye_alpha(vec3 eye_color){
	vec3 hsv = rgb2hsv(eye_color);
	float saturation_factor = hsv.y < 0.025 ? 1.0 : 0.0;
	float value_factor = hsv.z > 0.025 ? 1.0 : 0.0;
	return saturation_factor * value_factor;
}

vec2 pupil_transform(vec2 uv, vec2 offset, float scale, float rotation){
	vec2 centered = uv - vec2(0.5) - offset;
	float angle = rotation;
	vec2 rotated = vec2(centered.x * cos(angle) - centered.y * sin(angle), centered.x * sin(angle) + centered.y * cos(angle));
	vec2 scaled = rotated / scale;
	return scaled + vec2(0.5,0.5);
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 eye_left_colors = texture(eye_texture, UV2);
	vec4 pupil_left_colors = texture(pupil_texture,
		pupil_transform(
			pupil_uv_left,
			pupil_transform_left.xy,
			pupil_transform_left.z,
			pupil_transform_left.w));

	vec3 total_left = eye_left_colors.rgb * (pupil_left_colors.rgb * eye_alpha(eye_left_colors.rgb));

	vec4 eye_right_colors = texture(eye_texture, eye_uv_right);
	vec4 pupil_right_colors = texture(pupil_texture,
		pupil_transform(
			pupil_uv_right,
			pupil_transform_right.xy,
			pupil_transform_right.z,
			pupil_transform_right.w));

	vec3 total_right = eye_right_colors.rgb * (pupil_right_colors.rgb * eye_alpha(eye_right_colors.rgb));

	vec3 total_eyes = mix(total_left, total_right, eye_right_colors.a);
	float total_eyes_alpha = eye_left_colors.a + eye_right_colors.a;

	vec3 base_colors = texture(base_texture, UV).rgb;
	vec3 total_no_mouth = mix(base_colors, total_eyes, total_eyes_alpha);

	vec4 mouth_colors = texture(mouth_texture, mouth_uv);
	vec3 total_material = mix(total_no_mouth, mouth_colors.rgb, mouth_colors.a);

	ALBEDO = total_material;
}
