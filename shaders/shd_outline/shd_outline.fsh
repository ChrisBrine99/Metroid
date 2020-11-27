//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float pixelWidth;
uniform float pixelHeight;
uniform vec3 outlineColor;
uniform int drawOutline;

void main(){
	// Don't bother drawing an outline for objects that don't need an outline drawn
	if (drawOutline == 0){
		gl_FragColor = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
		return;
	}
	// Store the texture's initial RGB values into a vec3, which are overwritten for the outline
	vec3 baseColor = texture2D(gm_BaseTexture, v_vTexcoord).rgb;
	// Create vectors to store the pixel width and height for easy vector addition
	vec2 xOffset, yOffset, diagOffset;
	xOffset = vec2(pixelWidth, 0.0);
	yOffset = vec2(0.0, pixelHeight);
	// Get the alpha value of the current pixel
	float alpha = texture2D(gm_BaseTexture, v_vTexcoord).a;
	// Only attempt to create an outline on empty pixels
	if (alpha == 0.0){
		// Overwrite the base color (Black) with the outline's color
		baseColor = outlineColor;
		// The Left, Right, Up, and Down Edges of the pixel
		alpha += ceil(texture2D(gm_BaseTexture, v_vTexcoord + xOffset).a);
		alpha += ceil(texture2D(gm_BaseTexture, v_vTexcoord - xOffset).a);
		alpha += ceil(texture2D(gm_BaseTexture, v_vTexcoord + yOffset).a);
		alpha += ceil(texture2D(gm_BaseTexture, v_vTexcoord - yOffset).a);
		// Only check the corner pixels if absolutely necessary
		if (alpha == 0.0){
			// The Top-Left, Top-Right, Bottom-Left, and Bottom-Right pixels
			alpha += ceil(texture2D(gm_BaseTexture, v_vTexcoord + vec2(pixelWidth, pixelHeight)).a);
			alpha += ceil(texture2D(gm_BaseTexture, v_vTexcoord + vec2(-pixelWidth, pixelHeight)).a);
			alpha += ceil(texture2D(gm_BaseTexture, v_vTexcoord + vec2(-pixelWidth, -pixelHeight)).a);
			alpha += ceil(texture2D(gm_BaseTexture, v_vTexcoord + vec2(pixelWidth, -pixelHeight)).a);
		}
	}
	// Send the calculated color off for rendering
    gl_FragColor = v_vColour * vec4(baseColor, min(alpha, 1.0));
}
