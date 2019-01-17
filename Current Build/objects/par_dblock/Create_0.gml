/// @description Initialize the destructable block variables
// You can write your code in this editor

// Call the parent event's Create Event
event_inherited();

beenHit = false;
image_speed = 0;

// For setObject:
//	-1 = Anything Can Destroy The Block
//	 0 = Bombs/Power Bombs only
//	 1 = Missiles only
//	 2 = Super Missiles only
//	 3 = Power Bombs only
//	 4 = Screw Attack only