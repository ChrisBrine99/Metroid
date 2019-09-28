/// @description Insert description here
// You can write your code in this editor

// Edit the item's index and subIndex
index = ITEM.SPACE_JUMP;
subIndex = 0;

// Call the parent's create event
event_inherited();

// Create the ambient light for the Morphball
ambLight = instance_create_depth(x, y, 15, obj_light_emitter);
with(ambLight){
	xRad = 30;
	yRad = 30;
	lightCol = c_lime;
}

// Edit the object's name and description
itemName = "Space Jump";
itemDescription = "Pressing [" + draw_keyboard_key(0, 0, global.gKey[KEY.JUMP], c_white, c_white, false) + "] while airbourne will allow you to\njump again, which can be done indefinitely.";