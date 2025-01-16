shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_lambert, specular_schlick_ggx;

uniform sampler2D bricks;
uniform sampler2D noise : filter_nearest;
uniform vec2 scale_uniform;
uniform float rotate;
uniform float noiseRotate;
vec2 rotateUV(vec2 uv, vec2 pivot, float rotation) {
    float sine = sin(rotation);
    float cosine = cos(rotation);
    float oldx = uv.x;
    uv -= pivot;
    uv.x = uv.x * cosine - uv.y * sine;
    uv.y = oldx * sine + uv.y * cosine;
    uv += pivot;

    return uv;
}



void vertex() {
	UV = UV * scale_uniform;

}



void fragment() {
// Texture2D:7
	vec4 n_out7p0 = texture(bricks, rotateUV(UV, vec2(0.5), PI/rotate));


	vec3 n_out2p0;
// ColorFunc:2
	vec3 n_in2p0 = vec3(0.38000, 0.22000, 0.60000);
	{
		vec3 c = n_in2p0;
		vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
		vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
		n_out2p0 = c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
	}


// Texture2D:4
	vec4 n_out4p0 = texture(noise, rotateUV(UV, vec2(0.5), PI/noiseRotate));


// Mix:8
	vec3 n_out8p0 = mix(vec3(n_out7p0.xyz), n_out2p0, vec3(n_out4p0.xyz));


// Output:0
	ALBEDO = n_out8p0;


}
