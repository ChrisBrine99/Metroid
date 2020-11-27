//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float bloomIntensity;
uniform float bloomDarken;
uniform float bloomSaturation;
uniform sampler2D bloomTexture;

void main(){
	// Store the fragments for the base color and bloom color
	vec4 baseColor = texture2D(gm_BaseTexture, v_vTexcoord);
	vec3 bloomColor = texture2D(bloomTexture, v_vTexcoord).rgb;
	
	// Saturate the bloom color
	float luminence = dot(bloomColor, vec3(0.299, 0.587, 0.114));
	bloomColor = mix(vec3(luminence), bloomColor, bloomSaturation);
	
	// Add the bloom color and base color together
	baseColor.rgb = (baseColor.rgb * bloomDarken) + (bloomColor * bloomIntensity);
	
	// Send the calculated color off for rendering
    gl_FragColor = v_vColour * baseColor;
}
