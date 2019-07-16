/// @description Insert description here
// You can write your code in this editor

// Edit the item's index and subIndex
index = ITEM.GRAVITY_SUIT;
subIndex = 0;

// Call the parent's create event
event_inherited();

// Create the ambient light for the Morphball
ambLight = instance_create_depth(x, y, 15, obj_light_emitter);
with(ambLight){
	xRad = 30;
	yRad = 30;
	lightCol = c_fuchsia;
}

// Edit the object's name and description
itemName = "Gravity Suit";
itemDescription = "";
