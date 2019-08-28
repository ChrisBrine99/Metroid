/// @description Handles Moving Through/Closing the Menu
// You can write your code in this editor

#region Unique Keyboard Inputs

var keyCloseMenu;
keyCloseMenu = keyboard_check(global.gKey[KEY.SWAP_WEAPON]);		

#endregion

#region Controlling the Alpha Level

if (activeMenu){
	scr_alpha_control_update();
	if (fadingIn) {alphaChangeVal = 0.1;}
}

#endregion

#region Menu Input/Functionality

// Make sure that the selectedOption is never set
selectedOption[X] = -1;
selectedOption[Y] = -1;

// Call the parent's step event
event_inherited();

// Closing the Menu
if (!keyCloseMenu){
	fadingIn = false;
	activeMenu = false;
}

#endregion