varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float bloomIntensity;
uniform float bloomDarken;
uniform float bloomSaturation;
uniform sampler2D bloomTexture;

void main() {
	vec4 baseCol = texture2D(gm_BaseTexture, v_vTexcoord);
	vec3 bloomCol = texture2D(bloomTexture, v_vTexcoord).rgb;
	
	// Saturate the bloom color:
	float lum = dot(bloomCol, vec3(0.299, 0.587, 0.114));
	bloomCol = mix(vec3(lum), bloomCol, bloomSaturation);
	
	// Add (Linear Dodge):
	baseCol.rgb = ((baseCol.rgb * bloomDarken) + (bloomCol * bloomIntensity));
	
    gl_FragColor = v_vColour * baseCol;
}