shader_type spatial;
render_mode unshaded;
uniform sampler2D noise;
uniform sampler2D moreNoise;
uniform sampler2D albd: filter_nearest, repeat_enable;
varying vec2 tex_position;

float height(vec2 position, float time) {
  vec2 offset = 0.01 * cos(position + time);
  return texture(noise, (position / 20.0) - offset).x;
}
void vertex() {
  
  vec2 pos = VERTEX.xz;
  float k = height(pos, TIME/5.0);
  VERTEX.y = k;
 NORMAL = normalize(vec3(k - height(pos + vec2(0.1, 0.0), TIME), 0.1, k - height(pos + vec2(0.0, 0.1), TIME)));
COLOR = texture(moreNoise, UV);
}

void fragment() {
	
	vec4 noiseText = texture(moreNoise, UV);
	ALPHA = 1.0;
	ALBEDO = texture(albd,vec2(UV.x * 10.0, UV.y * 10.0)).rgb;
	RIM = 0.2;
  	METALLIC = 0.0;
	ROUGHNESS = 0.0;
	
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
