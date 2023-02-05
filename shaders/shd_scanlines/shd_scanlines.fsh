varying float yPosition;

uniform float opacity;

void main(){
	if (mod(yPosition, 2.0) < 1.0){ // Ensures every-other pixel has the effect applied to it
		gl_FragColor = vec4(vec3(0.0), opacity);
		return; // Exit before gl_FragColor is overwritten by the "invisible" default value.
	}
	gl_FragColor = vec4(0.0);
}