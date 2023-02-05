varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float blurRadius;
uniform float blurIntensity;
uniform vec2 blurTexelSize;
uniform vec2 blurDirection;

/// @description Calculates the weight of a pixel's color relative to the center pixel, which is the current
/// fragment that is being processed by the GPU; using the gaussian distribution equation to achieve a nice
/// looking screen blurring effect.
/// @param position
float fragmentWeight(float _position){
	return exp(-(_position * _position) / (2.0 * blurIntensity * blurIntensity));
}

void main(){
	// Sample the first pixel, which is the fragment that is currently being processed by the GPU. Then, set
	// the "totalWeight" variable to 1.0 since the center pixel is fully sampled for the blurring. Finally,
	// store the denominator for calculating the weight of a color at a given position relative to the current
	// fragment as a variable "kernel" since it doesn't change in the loop.
	highp vec4 blurredColor = texture2D(gm_BaseTexture, v_vTexcoord);
	float totalWeight = 1.0;
	float kernel = 2.0 * blurRadius + 1.0;
	
	// Loop through the pixels based on the direction of the "blurDirection" vector relative to the "radius"
	// of the blur, which determines how many pixels around the center fragment will effect this center
	// fragment's color for accurate blurring. It does two pixels per loop; one on either side of the fragment
	// relative to the blurring direction, to save on overall processing time.
	vec2 sampleFragment;
	float sampleWeight;
	for (float offset = 1.0; offset <= blurRadius; offset += 1.0){
		// First, calculate the weight of the current sample relative to the current offset from the center 
		// fragment. Then, the resulting sample is added to the total weight of the blurring on the current
		// pixel; multiplied by two since two samples are processed per loop.
		sampleWeight = fragmentWeight(offset / kernel);
		totalWeight += sampleWeight * 2.0; // Multiplied by 2 since two samples are taken per interation.

		// Sample from the first fragment offset, which will take the color of that pixel; located on the 
		// left OR top of the center fragment (Hence the "-" sign) to sample to correct fragment.
		sampleFragment = v_vTexcoord - offset * blurTexelSize * blurDirection;
		blurredColor += texture2D(gm_BaseTexture, sampleFragment) * sampleWeight;
		
		// The same process is performed again here, but for the pixels that are offset to the right OR 
		// bottom of the center fragment; adding that pixel's color to the center fragment based on the
		// current sampling rate.
		sampleFragment = v_vTexcoord + offset * blurTexelSize * blurDirection;
		blurredColor += texture2D(gm_BaseTexture, sampleFragment) * sampleWeight;
	}
	
	// Finally, set the color of the fragment to the calculated blur color divided by the total weight of
	// all the fragments that were sampled in the blurring process.
    gl_FragColor = v_vColour * blurredColor / totalWeight;
}
