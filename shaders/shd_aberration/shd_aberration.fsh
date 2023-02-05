varying vec2 v_vTexcoord;

uniform float intensity;

void main(){
	// Take the color at the current fragment that is being processed and store it into a vector so it can be
	// altered with the aberration effect if it meets the criteria to do so.
	vec4 baseColor = texture2D(gm_BaseTexture, v_vTexcoord);
	
	// Determine the strength of the aberration effect relative to the center point of the application surface.
	// Then, determine a distance vector based on that positional offset from the center.
	vec2 abrDistance = (v_vTexcoord - 0.5) * (v_vTexcoord - 0.5) * intensity;
	
	// Creating the aberration effect based on the distance vector that was calculated. In short, a mixture
	// of the base color, (50% R, 50% G, 33% B) the first additional sample, (Offset to the right of the 
	// current fragment; 50% R, 0% G, 33% B) and the second additional sample (Offset to the left of the base
	// fragment; 0% R, 50% G, 33% B) is created before that resulting fragment color is sent to the GPU.
	baseColor.rgb = baseColor.rgb * vec3(0.5, 0.5, 0.33) +
					texture2D(gm_BaseTexture, v_vTexcoord + abrDistance).rgb * vec3(0.5, 0.0, 0.33) +
					texture2D(gm_BaseTexture, v_vTexcoord - abrDistance).rgb * vec3(0.0, 0.5, 0.33);
    gl_FragColor = baseColor;
}