/// @description Setting the sprites that Samus will use in animations
// You can write your code in this editor

// Sprite variables ///////////////////////////////////////////////////////////////////////

if (global.variaSuit && !global.gravitySuit) // Load in the varia suit sprites
	scr_set_sprite_varia();
else if (global.gravitySuit) // Load in the gravity suit sprites
	scr_set_sprite_gravity();
else // Load in the power suit sprites
	scr_set_sprite_power();
	
///////////////////////////////////////////////////////////////////////////////////////////

// Other initializing stuff
with(obj_samus){
	if (!canMove){
		if (global.highJump)
			jumpSpd = -7.4;
		
		mask_index = spr_standing_mask;
		sprite_index = sprStand1;
		image_speed = 0;
	}
}