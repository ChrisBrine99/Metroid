varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float bloomThreshold; // lum < threshold:						is drawn black
uniform float bloomRange;	  // lum > threshold + range:				is drawn normally
							  // threshold < lum < threshold + range:	is drawn darkened
uniform sampler2D appTexture;

void main() {
	// Get the base colors of the pixel
	vec4 baseCol = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
	vec4 lightCol = v_vColour * texture2D(appTexture, v_vTexcoord);
	baseCol.rgb -= lightCol.rgb;
	// Get the luminance of it
	float lum = dot(baseCol.rgb, vec3(0.229, 0.587, 0.114));
	// lum < threshold, weight = 0 
	// lum > threshold + range, weight = 1
	// in between those two ranges is a smooth value between 0 and 1
	float weight = smoothstep(bloomThreshold, bloomThreshold + bloomRange, lum);
	// Mix the color depending on the weight of luminance
	baseCol.rgb = mix(vec3(0.0), baseCol.rgb, weight);
	
	// RESULT OF SHADER:
	//		Turns darker tone colors to pure black, leaving only the
	//		bright colors behind. In tandem with a blur shader, bloom
	//		will be created.
	
    gl_FragColor = baseCol;
}