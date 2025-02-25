shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_lambert_wrap, specular_toon, unshaded;

uniform sampler2D tex_frg_7;
uniform sampler2D tex_frg_8 : source_color;



void fragment() {
	vec4 n_out10p0;
// Texture2D:10
	n_out10p0 = vec4(0.0);


// Texture2D:7
	vec4 n_out7p0 = textureLod(tex_frg_7, UV, n_out10p0.x);


// UVFunc:5
	vec2 n_in5p1 = vec2(5.00000, 5.00000);
	vec2 n_in5p2 = vec2(0.00000, 0.00000);
	vec2 n_out5p0 = (UV - n_in5p2) * n_in5p1 + n_in5p2;


	vec4 n_out9p0;
// Texture2D:9
	n_out9p0 = vec4(0.0);


// Texture2D:8
	vec4 n_out8p0 = textureLod(tex_frg_8, n_out5p0, n_out9p0.x);


// VectorOp:12
	vec3 n_out12p0 = vec3(n_out7p0.xyz) * vec3(n_out8p0.xyz);


// Output:0
	ALBEDO = n_out12p0;


}
