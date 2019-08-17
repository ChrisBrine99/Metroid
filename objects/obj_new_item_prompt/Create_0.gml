/// @description Initializing Variables
// You can write your code in this editor

// Enable this object to use the alpha control scripts
scr_alpha_control_create();
// Let the on screen prompt destroy itself upon fading away
destroyOnZero = true;

isClosing = false;		// If true, the menu will fade away and disappear

itemName = "";			// The name of the item being displayed

displayTxt = "";		// The full unaltered sccreen
curDisplayedStr = "";	// The text that is currently being displayed on the screen
nextChar = 1;			// The next character to pulled from the "displayTxt" variable
curChar = 1;			// The current character that was added to the "curDisplayedStr" variable
txtSpeed = 2.5;			// How fast the text scrolling is

scrollingText = false;	// If true, the text will scroll out instead of being instantly visible

txtAlignment = fa_left;	// The alignment of the text on the screen
txtCol = c_white;		// The color of the text
txtOCol = c_gray;		// The color of the text's surrounding outline 
nameCol = c_white;		// The color of the item name
nameOCol = c_gray;		// The color of the item name text's outline

creatorID = noone;		// The instance ID of the object that created this

// Create the background blur
blurID = instance_create_depth(0, 0, 40, obj_blur);
blurID.sigma = 0.001;

// Make the HUD invisible and freeze the Camera
with(obj_hud) {isVisible = false;}
with(obj_camera) {curObject = false;}

// Stores which fanfare was played during collection
fanfare = music_item_fanfare;