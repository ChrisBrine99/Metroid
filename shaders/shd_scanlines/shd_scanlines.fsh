//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float viewHeight;
uniform float strength;

void main() {
	// Calculate which row of pixels we're currently on. Even == scanline, Odd == no scanline
	float curPixelY = floor(v_vTexcoord.y * viewHeight);
	if (mod(curPixelY, 2.0) == 0.0){ // Darken every other line of pixels on the screen to simulate scanlines
		gl_FragColor = v_vColour * vec4(0.0, 0.0, 0.0, strength);
	}
}
