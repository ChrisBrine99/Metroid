/// @description Insert description here
// You can write your code in this editor

// Edit the item's index
index = ITEM.POWER_BOMBS;
// NOTE -- subIndex is initialized in the creation code

// Call the parent's create event
event_inherited();

// Create the ambient light for the Morphball
ambLight = instance_create_depth(x, y, 15, obj_light_emitter);
with(ambLight){
	xRad = 30;
	yRad = 30;
	lightCol = c_orange;
}

// Setup the item's name and description
alarm[1] = 1;