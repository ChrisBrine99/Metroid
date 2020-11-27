/// @description Variable Initialization

#region EDITING INHERITED VARIABLES

image_index = 0;
image_speed = 0;
image_alpha = 0;
visible = false;

#endregion

#region UNIQUE VARIABLE INITIALIZATION

// Variables that store the current transition script to execute and the arguments pertaining to that transition
// script, respectively. The arguments are contained within an array in order to allow the scripts to take in
// whatever number of arguments they choose, while only every actually using a single argument slot.
transition = -1;
transitionArgs = -1;	// An array of indefinite length

// A variable that stores a method's ID value. Whenever the variable is used, the relative state code will
// be executed, and for only that state's code. The lastState variable stores the previously active state.
curState = -1;
lastState = -1;
// Menus can use the entity's set_cur_state to change state, much like an entity object

// Variables relating to the options that the user has currently highlighted, selected, and a previous auxillary
// option that they have selected -- one that is needed for certain tasks. (Ex. Combining Items, Swapping Items 
// Between Slots, etc.)
curOption = 0;
prevOption = 0;
selOption = -1;
auxSelOption = -1;

// Variables related to drawing the menu's visible region of options. The first vector determines the earliest
// drawn row and column -- offset from the first element of each by the values. Then, the offset determines
// how close to the border of the visible region the user needs to highlight before the visible region will
// shift over by one row/column. The dimension vector just stores the total number of rows and columns found
// in the menu.
firstDrawn = 0;			// A 2D vector [X, Y]
numDrawn = 0;			// A 2D vector [X, Y]
scrollOffset = 0;		// A 2D vector [X, Y]
menuDimensions = 0;		// A 2D vector [X, Y]

// These variables are for automatically scrolling through the menu's options. The first is the time
// (60 == 1 second) the menu movement key has been held for, the time it needs to be held in order to 
// automatically move the cursor, the speed relative to the time needed to hold that the cursor will 
// move once autoscrolling has been activated, and finally, the flag to toggle automatic cursor scrolling 
// on and off.
holdTimer = 0;
timeToHold = 30;
autoScrollSpeed = 0.4;
isAutoScrolling = false;

// Keyboard input state flags that track when a button is held/released/pressed. True means it's pressed or
// held down by the user, and false means the key has been released.
keyRight = false;
keyLeft = false;
keyUp = false;
keyDown = false;
keySelect = false;
keyReturn = false;
keyAuxReturn = false;

// The index values for some of the configurable keybindings. These include the cursor's directional keys,
// which allow the user to move through the menu, and the auxillary return key, which can be used to allow
// for a secondary key that acts as a return key.
rightIndex = vk_right;
leftIndex = vk_left;
upIndex = vk_up;
downIndex = vk_down;
auxReturnIndex = -1;

// Holds the index for the shader used for outlining text. Note that these are just for easy reference
// and the shader should actually be set in an object that handles drawing all the menu's in a single
// shader pass.
outlineShader = shd_outline;
// Getting the uniforms for the shader; storing them in local variables
sPixelWidth = shader_get_uniform(outlineShader, "pixelWidth");
sPixelHeight = shader_get_uniform(outlineShader, "pixelHeight");
sOutlineColor = shader_get_uniform(outlineShader, "outlineColor");
sDrawOutline = shader_get_uniform(outlineShader, "drawOutline");

// VARIABLES FOR MENU TITLE ////////////////////////////////////////////////////////

// The string for the title that will displayed at its positional coordinates; aligned to that position
// using the alignment vector. Finally, there is the font that will be used to draw said title.
title = "";
titlePos = 0;			// A 2D vector [X, Y]
titleAlign = 0;			// A 2D vector [X, Y]
titleFont = -1;

// The color of the title's text and respective outline.
titleTextCol = c_white;
titleOutlineCol = [0.5, 0.5, 0.5];

////////////////////////////////////////////////////////////////////////////////////

// VARIABLES FOR MENU OPTIONS //////////////////////////////////////////////////////

// The ds_list that stores all the string values for the available menu options.
option = ds_list_create();			// A ds_list of indefinite length (string)
optionActive = ds_list_create();	// A ds_list of indefinite length (boolean)
// The position of the top element for the displayed options, the offsets for each option, and the spacing
// between each of the options on each axis.
optionPos = 0;						// A 2D vector [X, Y]
optionPosOffset = ds_list_create();	// A ds_list of indefinite length (x, y)
optionSpacing = 0;					// A 2D vector [X, Y]
// The alignment of the options relative to their posiiton value, as well as the font used for the options.
optionAlign = 0;					// A 2D vector [X, Y]
optionFont = -1;
// Redundant data that stores the size of the option ds_list for ease of use.
numOptions = 0;

// The colors used for options that aren't selected or being highlighted by the user current, but they are
// currently visible.
optionCol = c_white;
optionOutlineCol = [0.5, 0.5, 0.5];
// The colors used for a menu action that is disbled. A disabled option means that the player cannot currently
// interact with it and it won't be highlighted by the menu cursor.
optionInactiveCol = c_gray;
optionInactiveOutlineCol = [0.25, 0.25, 0.25];
// The first two variables are the colors used for the option that was selected by the user. Meanwhile, the
// second pair of variables are used for an option that was selected by the user, but it now stored in an
// auxillary buffer for use once another option is selected by the user. (Ex. Combining Items, Swapping Items)
optionSelectCol = c_lime;
optionSelectOutlineCol = [0, 0.5, 0];
optionAuxSelectCol = c_red;
optionAuxSelectOutlineCol = [0.5, 0, 0];
// The colors used for the option the is equal to the curOption value, meaning it is being hovered over by 
// the user, but it hasn't been selected yet.
optionHighlightCol = make_color_rgb(252, 224, 168);
optionHighlightOutlineCol = [0.49, 0.44, 0.33];

////////////////////////////////////////////////////////////////////////////////////

// VARIABLES FOR MENU OPTIONS INFO /////////////////////////////////////////////////

// The ds_list that stores all the string values for the available menu option information. Also, below that
// is the vector to store the position of the information on the screen, and another vector for the alignment
// of that text relative to the position of the information. Finally, the font is found below those variables.
info = ds_list_create();			// A ds_list of indefinite length (string)
infoPos = 0;						// A 2D vector [X, Y]
infoAlign = 0;						// A 2D vector [X, Y]
infoFont = -1;

// The color of both the inside of the iunformation text and its accompanying outline.
infoTextCol = c_white;
infoOutlineCol = [0.5, 0.5, 0.5];

// A flag that enables/disables the information text to smoothly scroll onto the screen for displaying. The
// variable below that is the number of currently visible characters, which is increased relative to the 
// text speed setting in the accessibility menu.
scrollingInfoText = false;
numCharacters = 0;

////////////////////////////////////////////////////////////////////////////////////

// VARIABLES FOR MENU CONTROL INFO /////////////////////////////////////////////////

// The two choices for anchors that the control information can be positioned relative to. One if for the
// left-side of the screen, and the other is for the right-side of the screen.
leftAnchor = 0;						// A 2D vector [X, Y]
rightAnchor = 0;					// A 2D vector [X, Y]

// The control information is contained over 3 ds_lists that each store unique information relative to the
// "index". The first is the calculated position of the control information relative to the anchor it uses.
// The second is for the anchor that the control positions are calculated from. The third contains the string
// telling the user what the control does in the menu, and the image that goes along with that keybinding.
// Below that is the font used for displaying the control information.
controlsPos = ds_list_create();		// A ds_list of indefinite length (X, Y)
controlsAnchor = ds_list_create();	// A ds_list of indefinite length (element(s) must be either -1 or 1)	
controlsInfo = ds_list_create();	// A ds_list of indefinite length (sprite_index, image_index, string) 
controlsFont = -1;

// The color of both the inside of the iunformation text and its accompanying outline.
controlsTextCol = c_white;
controlsOutlineCol = [0.5, 0.5, 0.5];

///////////////////////////////////////////////////////////////////////////////////

#endregion

/*

// FOR TESTING OPTIONS/MENU MOVEMENT //////////////////////////////////////////////

// Initialize the most important menu variables
menu_initialize(-1, -1, 6, 3, 10, 1, 3, 15, 0.3);

// Initialize the menu options
menu_init_options(20, 15, fa_left, fa_top, 50, 10, font_gui_medium);
for (var i = 0; i < 75; i++){
	options_add_info("TEST " + string(i), "TEST INFORMATION " + string(i), true);
}

///////////////////////////////////////////////////////////////////////////////////

// FOR TESTING CONTROL DISPLAYING ////////////////////////////////////////////////

menu_init_control_info(5, global.cameraSize[Y] - 12, global.cameraSize[X] - 5, global.cameraSize[Y] - 12, font_gui_small, c_white, [0.5, 0.5, 0.5]);

controls_add_info(ord("Z"), LEFT_ANCHOR, "Select", false);
controls_add_info(ord("X"), LEFT_ANCHOR, "Return", true);

controls_add_info(vk_right, RIGHT_ANCHOR, "", false);
controls_add_info(vk_left, RIGHT_ANCHOR, "", false);
controls_add_info(vk_up, RIGHT_ANCHOR, "", false);
controls_add_info(vk_down, RIGHT_ANCHOR, "Move Cursor", true);

////////////////////////////////////////////////////////////////////////////////////

*/