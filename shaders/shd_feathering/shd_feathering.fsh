varying vec2 position;
varying vec2 texcoord;
varying vec4 color;

uniform vec4 fadeStart;
uniform vec4 fadeEnd;

void main(){
	// 
	vec4 baseColor = texture2D( gm_BaseTexture, texcoord );
	float alpha = baseColor.a;
	
	//
	if (position.x < fadeEnd.x || position.x > fadeEnd.z || position.y < fadeEnd.y || position.y > fadeEnd.w){
		gl_FragColor = vec4(0.0);
		return;
	}
	
	//
	float xWeight = 0.0;
	if (position.x < fadeStart.x)		{xWeight = 1.0 - smoothstep(fadeEnd.x, fadeStart.x, position.x);}
	else if (position.x > fadeStart.z)	{xWeight = smoothstep(fadeStart.z, fadeEnd.z, position.x);}
	
	//
	float yWeight = 0.0;
	if (position.y < fadeStart.y)		{yWeight = 1.0 - smoothstep(fadeEnd.y, fadeStart.y, position.y);}
	else if (position.y > fadeStart.w)	{yWeight = smoothstep(fadeStart.w, fadeEnd.w, position.y);}
	
	// 
	alpha = max(0.0, (1.0 - (xWeight * xWeight + yWeight * yWeight)) * alpha);
	
	// 
    gl_FragColor = color * vec4(baseColor.rgb, alpha);
}
