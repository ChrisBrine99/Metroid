/// @description Insert description here
// You can write your code in this editor

// Call the parent object's create event
event_inherited();
// Allow the menu to select and return
canUseSelect = true;
canUseReturn = true;

// Variables that are unique to all Sub Menus
inheritAllSounds = false;	// If true, the sub menu will poroduce the same sounds as the menu that created it
xPos = 0;					// The x coordinate of the sub menu on the GUI layer
yPos = 0;					// The y coordinate of the sub menu on the GUI layer
font = font_gui_small;		// The font that the menu will use. Can be carried over from the previous menu
otherIndex = -1;			// The index of the current selected option on the menu that created this one

drawOptionBgs = true;		// If false, no background will be drawn for the options in the menu
bgWidth = 120;				// The width in pixels of the menu option's rectangle
bgHeight = 15;				// The height in pixels of the menu option's rectangle
bgCol = make_color_rgb(20, 20, 20);
bgSelCol = make_color_rgb(50, 50, 50);

xPosD = 0;					// The X position of the menu's option descriptions
yPosD = 0;					// The Y position of the menu's option descriptions

displayTxt = "";			// The full unaltered string of text
curDisplayedStr = "";		// The text that is currently being displayed on the screen
nextChar = 1;				// The next character to pulled from the "displayTxt" variable
curChar = 1;				// The current character that was added to the "curDisplayedStr" variable
txtSpeed = 2.5;				// How fast the text scrolling is