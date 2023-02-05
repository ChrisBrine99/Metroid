varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float threshold;
uniform float range;

void main(){
	// Store the initial color of the fragment, which is then manipulated below.
	vec4 baseColor = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	
	// First, calculate the luminance of the fragment, which is found by taking the fragment's rgb values
	// and calculating the dot product of that vector against the NTSC color vector's rgb values.
	float lum = dot(baseColor.rgb, vec3(0.299, 0.587, 0.114));
	
	// Using the luminance, the "weight" for the fragment's color is calculated. If it's lower than the
	// threshold value, the weight will turn the color completely black. If it's higher than the threshold
	// plus the range, the color is left as is. Otherwise, the color is a mixture between that threshold and
	// range values relative to the calculated luminance value of the fragment.
	float weight = smoothstep(threshold, threshold + range, lum);
	
	// Finally, mix the color black with the color found at the current fragment based on the calculated value
	// that is stored within the "weight" variable. After that, the color is sent off to the GPU.
	baseColor.rgb = mix(vec3(0.0), baseColor.rgb, weight);
    gl_FragColor = baseColor;
}
