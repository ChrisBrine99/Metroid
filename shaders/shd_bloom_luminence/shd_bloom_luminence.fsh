//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float bloomThreshold;
uniform float bloomRange;

void main(){
	vec4 baseColor = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
	
	float luminence = dot(baseColor.rgb, vec3(0.229, 0.587, 0.114));
	float weight = smoothstep(bloomThreshold, bloomThreshold + bloomRange, luminence);
	baseColor.rgb = mix(vec3(0.0), baseColor.rgb, weight);
	
    gl_FragColor = baseColor;
}
