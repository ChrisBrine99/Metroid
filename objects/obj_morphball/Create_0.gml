/// @description Insert description here
// You can write your code in this editor

// Edit the item's index and subIndex
index = ITEM.MORPHBALL;
subIndex = 0;

// Call the parent'screate event
event_inherited();

// Create the ambient light for the Morphball
ambLight = instance_create_depth(x, y, 15, obj_light_emitter);
with(ambLight){
	xRad = 30;
	yRad = 30;
	lightCol = make_color_rgb(215, 180, 255);
}

// Edit the object's name and description
itemName = "Morphball";
itemDescription = "Pressing [" + draw_keyboard_key(0, 0, global.gKey[KEY.GAME_DOWN], c_white, c_white, false) + "] while crouching to enter morphball mode.\nWith this mode you can access narrow passageways.";