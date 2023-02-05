varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float pixelWidth;
uniform float pixelHeight;
uniform bool drawOutline;
uniform bool drawCorners;
uniform vec3 color;

void main(){
	// Store the texture's initial RGB values into a vec3, which are overwritten for the outline
	vec4 baseColor = texture2D(gm_BaseTexture, v_vTexcoord);
	// Don't bother drawing an outline for objects that don't need an outline drawn
	if (!drawOutline || baseColor.a > 0.0){
		gl_FragColor = v_vColour * baseColor;
		return;
	}
	// Create vectors to store the pixel width and height for easy vector addition
	vec2 xOffset, yOffset, diagOffset;
	xOffset = vec2(pixelWidth, 0.0);
	yOffset = vec2(0.0, pixelHeight);
	// Get the alpha value of the current pixel
	float alpha = 0.0;
	// The left, right, up, and down edges of the pixel
	alpha += texture2D(gm_BaseTexture, v_vTexcoord + xOffset).a;
	alpha += texture2D(gm_BaseTexture, v_vTexcoord - xOffset).a;
	alpha += texture2D(gm_BaseTexture, v_vTexcoord + yOffset).a;
	alpha += texture2D(gm_BaseTexture, v_vTexcoord - yOffset).a;
	// Only check the corner pixels if absolutely necessary
	if (drawCorners && alpha == 0.0){
		// The top-left, top-right, bottom-left, and bottom-right pixels
		alpha += texture2D(gm_BaseTexture, v_vTexcoord + vec2(pixelWidth, pixelHeight)).a;
		alpha += texture2D(gm_BaseTexture, v_vTexcoord + vec2(-pixelWidth, pixelHeight)).a;
		alpha += texture2D(gm_BaseTexture, v_vTexcoord + vec2(-pixelWidth, -pixelHeight)).a;
		alpha += texture2D(gm_BaseTexture, v_vTexcoord + vec2(pixelWidth, -pixelHeight)).a;
	}
	// Send the calculated outline pixel off for rendering
    gl_FragColor = vec4(color, min(ceil(alpha), 1.0) * v_vColour.a);
}
