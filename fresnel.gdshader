shader_type spatial;

uniform vec3 tint : source_color = vec3(1.0, 1.0, 1.0);

vec3 fresnel_glow(float amount, float intensity, vec3 color, vec3 normal, vec3 view) {
	return pow((1.0 - dot(normalize(normal), normalize(view))), amount) * color * intensity;
}


void fragment() {
	vec3 base_color = vec3(0.0, 0.0, 0.0);
	vec3 fresnel = fresnel_glow(1.5, 0.5, tint, NORMAL, VIEW);
	ALBEDO = fresnel;
	ALPHA = (fresnel.r + fresnel.g + fresnel.b) / 3.0;
}
