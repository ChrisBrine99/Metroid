//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec3 color;

uniform float brightness;
uniform float contrast;
uniform float saturation;

uniform sampler2D lightTexture;

void main(){
	// Store the initial texture sent into the shader
	vec3 baseColor = texture2D(gm_BaseTexture, v_vTexcoord).rgb;
	
	// Get the gray scale value based on the NTSC vector
	float gray = dot(baseColor, vec3(0.299, 0.587, 0.114));
	
	// Determine the initial out color based on the grayscale value, base color, and lighting color
	vec3 outColor = gray > 0.5 ? 1.0 - (1.0 - 2.0 * (baseColor - 0.5)) * (1.0 - color) : 2.0 * baseColor * color;
	// Add saturation, contrast, and brightness; in that order
	outColor = mix(vec3(gray), outColor, saturation);
	outColor = (outColor - 0.5) * contrast + 0.5;
	outColor = outColor + brightness;
	
	// Finally, incorporate the lights into the outColor values
	vec3 lightColor = texture2D(lightTexture, v_vTexcoord).rgb;
	gray = dot(lightColor, vec3(0.333));
	outColor = mix(outColor, baseColor * normalize(lightColor + 0.05) * 3.0, gray);
	outColor += 0.1 * lightColor;
	
	// Send the calculated color off for rendering
    gl_FragColor = vec4(outColor, 1.0);
}
