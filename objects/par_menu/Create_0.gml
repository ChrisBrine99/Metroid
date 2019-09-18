/// @description Initializing Variables
// You can write your code in this editor

// Makes the code for selecting/moving elements around more readable
#macro X 0
#macro Y 1

numRows = 0;				// The number of rows in the menu
numColumns = 0;				// The number of columns in the menu
firstDrawn = [0, 0];		// The first drawn elements (The top-left corner option)
numToDraw = [5, 5];			// How many elements will be visible to the player at once in the menu
// NOTE -- The Menu's total Size is the number of rows multiplied by the number of columns
curOption = [0, 0];			// The current option that is being high-lighted by the user
selectedOption = [-1, -1];	// The item in the menu that the user selected
prevMenuOption = [0, 0];	// The option that was selected to open this menu in the menu before it
activeMenu = false;			// If false, the menu will be unable to function (Ex. during transitions)
isClosing = false;			// If true, closing this menu will cause the previous menu to appear
canUseReturn = false;		// If true, the return key will be enabled for use
canUseSelect = false;		// If true, the select key will be enabled for use 

nextMenu = noone;			// Holds a reference to the menu that will be created by the current one
prevMenu = noone;			// Holds a reference to the menu that created this menu (Ex. Settings Menu would have the Main Menu as its prevMenu)

menuOption[0, 0] = "";		// Holds the names of the various menu options
optionDesc[0, 0] = "";		// An array to hold an item's description for when highlighted
menuSprite[0, 0] = -1;		// Holds the icon for the menu item (Can go unused)

autoScroll = 0;				// 0 = No Auto-Scrolling, 1 = Holding Before Auto-Scroll, 2 = Auto-Scrolling is active
shiftTimer = 8;				// The time in frames between menu elements automatically being scrolled
timeToAuto = 20;			// The time in frames before the menu starts auto-scrolling
holdTimer = timeToAuto;		// The timer to count down the frames

// Enable the alpha controller in every menu for smooth transitioning
scr_alpha_control_create();
// Let the Alpha Control know that it will destroy this object when transparent
destroyOnZero = true;

// The sounds that are produced by the menu
openSound = -1;				// The sound the menu makes when first opening
closeSound = -1;			// The sound the menu makes when closing
switchSound = -1;			// The sound that is produced when the user switches between menu options
selectSound = -1;			// The sound that is produced when the user selects a menu option

// Trigger the opening alarm
alarm[0] = 1;

// Variables to check if a transition object is needed
transitionObj = noone;