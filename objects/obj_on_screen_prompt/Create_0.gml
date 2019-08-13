/// @description Initializing Variables
// You can write your code in this editor

// Enable this object to use the alpha control scripts
scr_alpha_control_create();
// Let the on screen prompt destroy itself upon fading away
destroyOnZero = true;

// The text itself
displayTxt = "";

// The position and alignment of the text on screen
xPos = 0;
yPos = 0;
txtAlignment = fa_center;

// The font, color and opacity for the text
font = font_gui_xSmall;
displayTxtCol = c_white;
displayTxtOCol = c_gray;

// The time until the displayed message begins fading away
displayTimer = 90;

// If true, the player will be frozen until the prompt disappears
freezePlayer = false;