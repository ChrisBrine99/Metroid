varying vec2 position;
varying vec2 texcoord;

uniform vec3 color;
uniform float brightness;
uniform float saturation;
uniform float contrast;
uniform sampler2D lightTexture;

void main(){
	// 
	vec3 texColor = texture2D(gm_BaseTexture, texcoord).rgb;
	float gray = dot(texColor, vec3(0.299, 0.587, 0.114));

	// 
	vec3 outColor = gray > 0.5 ? 1.0 - (1.0 - 2.0 * (texColor - 0.5)) * (1.0 - color) : 2.0 * texColor * color;
	outColor = mix(vec3(gray), outColor, saturation);
	outColor = (outColor - 0.5) * contrast + 0.5;
	outColor = outColor + brightness;
	
	// 
	vec3 lightColor = texture2D(lightTexture, texcoord).rgb;
	gray = dot(lightColor, vec3(0.333)); // Changes from NTSC gray conversion to an even 33% RGB gray color.
	outColor = mix(outColor, texColor * normalize(lightColor + 0.05) * 3.0, gray) + (0.1 * lightColor);
	
	// 
    gl_FragColor = vec4(outColor, 1.0);
}
