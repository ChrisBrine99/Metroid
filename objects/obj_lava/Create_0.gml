/// @description Insert description here
// You can write your code in this editor

// Call the parent's create event
event_inherited();
sprite_index = spr_lava_visible;

// Edit some of the inherited variables
damage = 0;
dmgTimerMax = 10;

// Variables that are unique to the Lava Hazard
origin = image_yscale * 20;		// The maximum size the light can be
intensity = 1;					// How intense the light currently is
pulseTime = 12;					// Time in delta frames (60) between intensity switches
decIntensity = true;			// If true, the light will be getting brighter

// Edit the ambient light to fit how lava produces light
var xSize, ySize;
xSize = image_xscale * 16;
ySize = image_yscale * 20;
with(ambLight){
	y -= ySize;
	xRad = xSize;
	yRad = ySize;
	subLightHeight = round(ySize * 0.8);
	lightCol = make_color_rgb(255, 215, 155);
	lightType = LIGHT.RECT_FADE;
}