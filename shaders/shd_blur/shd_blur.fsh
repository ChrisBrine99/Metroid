//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float blurSteps;
uniform vec2 texelSize;
uniform float sigma;
uniform vec2 blurVector;

float weight(float pos){
	return exp(-(pos * pos) / (2.0 * sigma * sigma));
}

void main(){
	// Create a vec4 to store the final resulting blur color
	vec4 blurredColor = texture2D(gm_BaseTexture, v_vTexcoord);
	
	vec2 sample; // Stores the current sample pixel to take color from
	float offset, sampleWeight;
	float totalWeight = 1.0;
	float kernel = 2.0 * blurSteps + 1.0;
	// Loop from the first offset pixel on the right to the final one. Halves the amount of loops needed for calculation
	for (offset = 1.0; offset <= blurSteps; offset++){
		// Get the sample weight for the current offset pixel AND the mirrored pixel on the left
		sampleWeight = weight(offset / kernel);
		totalWeight += sampleWeight * 2.0; // Multiplied by two to factor in the mirrored pixel
		
		// Get the sample color for the offset pixel and add it to the blurred color
		sample = v_vTexcoord + offset * texelSize * blurVector;
		blurredColor += texture2D(gm_BaseTexture, sample) * sampleWeight;
		
		// Get the sample color for the mirrored pixel within the same loop
		sample = v_vTexcoord - offset * texelSize * blurVector;
		blurredColor += texture2D(gm_BaseTexture, sample) * sampleWeight;
	}
	
	// Send the calculated color off for rendering
    gl_FragColor = v_vColour * blurredColor / totalWeight;
}