//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float time;
uniform float size;
uniform float strength;
uniform sampler2D hazeTexture;

void main(){
	vec2 distortion;
	distortion.x = texture2D(hazeTexture, fract(v_vTexcoord * size + vec2(0.0, time))).r * strength;
	distortion.y = texture2D(hazeTexture, fract(v_vTexcoord * size * 3.7 + vec2(0.0, time * 1.6))).g * strength * 1.3;
	
	vec4 baseColor = texture2D(gm_BaseTexture, v_vTexcoord + distortion);
	baseColor.g -= strength * 7.0;
	baseColor.b -= strength * 18.0;
	
    gl_FragColor = v_vColour * baseColor;
}
