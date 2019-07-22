/// @description Insert description here
// You can write your code in this editor

// Edit the item's index and subIndex
index = ITEM.ICE_BEAM;
subIndex = 0;

// Call the parent's create event
event_inherited();

// Create the ambient light for the Morphball
ambLight = instance_create_depth(x, y, 15, obj_light_emitter);
with(ambLight){
	xRad = 30;
	yRad = 30;
	lightCol = make_color_rgb(255, 250, 165);
}

// Edit the object's name and description
itemName = "Plasma Beam";
itemDescription = "An upgrade that allows the arm cannon to shoot a blast\nof pure energy that can phase through anything with\ntremendous power. Opens maroon doors.";