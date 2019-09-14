/// @description Initializing the HUD variables
// You canwrite your code in this editor

// Destroy if another HUD already exists
if (global.hudID != noone){
	if (global.hudID.object_index == obj_hud){
		instance_destroy(self);	
	}
}
global.hudID = id;

// Enable this object to use the alpha control scripts
scr_alpha_control_create();

// If false, the HUD will no longer be visible
isVisible = false;

// Other Variables for HUD elements
global.curAmmo = 0;
global.maxAmmo = 0;
global.iconSpr = spr_powerbeam_icon;