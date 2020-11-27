//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float aberration;

void main(){
	// Create a vec4 to store the final resulting aberration color
	vec4 baseColor = texture2D( gm_BaseTexture, v_vTexcoord );
	
	// Calculate aberration strength based on distance from the center of the camera
	float dist = length(v_vTexcoord - 0.5);
	vec2 abrDistance = vec2(smoothstep(0.0, 10.0, dist) * aberration);
	baseColor.rgb = baseColor.rgb * vec3(0.5, 0.5, 0.33) + 
					texture2D(gm_BaseTexture, v_vTexcoord + abrDistance).rgb * vec3(0.5, 0.0, 0.33) + 
					texture2D(gm_BaseTexture, v_vTexcoord - abrDistance).rgb * vec3(0.0, 0.5, 0.33);
	
	// Send the calculated color off for rendering
    gl_FragColor = baseColor;
}
