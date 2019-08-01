/// @description Initializing Variables
// You can write your code in this editor

// Variables for the ambient light that can surround certain entities
ambLight = noone;		// The unique instance ID for this object's ambient light
xOffset = 7;			// The offset on the x-axis that the light should be placed at
yOffset = 7;			// The offset on the y-axis that the light should be placed at

// If true, the item will be destroyed and not give out its reward.
hasCollected = false;

// Variables that will be passed onto the item prompt object
itemName = "Default Name";
itemDescription = "Default Description";
scrollingText = true;						// If true, the item's description text will scroll onto the screen
nameCol = c_red;							// The color of the item name
nameOCol = c_maroon;						// The color of the item name text's outline
fanfare = music_item_fanfare;				// The music that will play unpon the item being collected

// Check if the object has already been collected
alarm[0] = 1;