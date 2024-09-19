shader_type spatial;
group_uniforms wind;
uniform sampler2D noise_tex;
uniform float wind_speed = .1;
uniform float wind_strength = .01;
uniform vec3 new_color : source_color;
void vertex() {

	vec3 GLOBAL_VERTEX = (MODEL_MATRIX * vec4(VERTEX, 1.)).xyz;

	float offset = TIME * wind_speed;
	float noise = texture(noise_tex, vec2(GLOBAL_VERTEX.x-offset)).r;
	noise -= .5;
	noise *= wind_strength;
	VERTEX.xy += noise * length(VERTEX.y) * length(VERTEX.xz);
}

void fragment() {
	ALBEDO = new_color;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
