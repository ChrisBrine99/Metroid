varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float blur_steps;
uniform vec2 texel_size;
uniform float sigma;
uniform vec2 blur_vector;

float weight(float pos) {
	return exp(-(pos * pos) / (2.0 * sigma * sigma));
}

void main() {
	highp vec4 blurred_col = vec4(0.0);
	
	vec2 sample;
	float offset, sample_weight;
	float total_weight = 0.0;
	float kernel = 2.0 * blur_steps + 1.0;
	
	for (offset = -blur_steps; offset <= blur_steps; offset++) {
		sample_weight = weight(offset / kernel);
		total_weight += sample_weight;
		
		sample = v_vTexcoord + offset * texel_size * blur_vector;
		blurred_col += texture2D(gm_BaseTexture, sample) * sample_weight;
	}
	
    gl_FragColor = v_vColour * blurred_col / total_weight;
}