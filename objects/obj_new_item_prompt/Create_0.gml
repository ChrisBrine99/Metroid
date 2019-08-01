/// @description Initializing Variables
// You can write your code in this editor

alpha = 0;				// The transparency level of the menu
isClosing = false;		// If true, the menu will fade away and disappear

itemName = "";			// The name of the item being displayed

displayTxt = "";		// The full unaltered sccreen
curDisplayedStr = "";	// The text that is currently being displayed on the screen
nextChar = 1;			// The next character to pull form the "displayTxt" variable

scrollingText = false;	// If true, the text will scroll out instead of being instantly visible

txtAlignment = fa_left;	// The alignment of the text on the screen
txtCol = c_white;		// The color of the text
txtOCol = c_gray;		// The color of the text's surrounding outline 
nameCol = c_white;		// The color of the item name
nameOCol = c_gray;		// The color of the item name text's outline

creatorID = noone;		// The instance ID of the object that created this

// Create the background blur
blurID = instance_create_depth(0, 0, 50, obj_blur);
blurID.sigma = 0.001;

// Make the HUD invisible
with(obj_hud) {isVisible = false;}

// Stores which fanfare was played during collection
fanfare = music_item_fanfare;