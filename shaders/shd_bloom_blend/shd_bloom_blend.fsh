varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float intensity;
uniform float darkenAmount;
uniform float saturation;
uniform sampler2D bloomTexture;


void main(){
	// Grab the color sample of the base texture's current fragment as well as the color found at the same
	// coordinate on the bloom luminance texture; storing both of these in two separate vectors.
	vec4 baseColor = texture2D(gm_BaseTexture, v_vTexcoord);
	vec3 bloomColor = texture2D(bloomTexture, v_vTexcoord).rgb;
	
	// Applying saturation to the bloom texture's current fragment by first getting the luminance value of 
	// said fragment. To do this, the color values of the fragment are used alongside the NTSC color vector
	// to product a grayscale vector that is then mixed into the bloom fragment color based on the value
	// for the saturation uniform.
	float lum = dot(bloomColor, vec3(0.299, 0.587, 0.119));
	bloomColor = mix(vec3(lum), bloomColor, saturation);
	
	// Finally, darken the base color by the amount determined by that respective uniform, and then add the
	// bloom texture's fragment color to it; the amount added being relative to the "intensity" uniform value.
	// After that, the fragment is passed off to be rendered by the GPU.
	baseColor.rgb = baseColor.rgb * darkenAmount + bloomColor * intensity;
    gl_FragColor = v_vColour * baseColor;
}
