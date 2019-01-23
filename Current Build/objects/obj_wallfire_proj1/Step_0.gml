/// @description Insert description here
// You can write your code in this editor

// Call the entity's gravity script
scr_entity_gravity();

// Making the bomb bounce
if (onGround){
	// The BOUNCE
	if (vspdRecoil < 0){
		if (image_xscale > 0)
			hspd = maxHspd;
		else if (image_xscale < 0)
			hspd = -maxHspd;
		vspd = vspdRecoil;
		audio_play_sound(snd_bomb_deploy, 1, false);
	}
}
else{
	// The BOUNCE
	if (vspd >= 2)
		vspdRecoil = -(vspd / 2);
	else
		vspdRecoil = 0;
}

// Countdown until the bomb explodes
if (hspd == 0 && vspdRecoil == 0){
	timer--;
	// Blow up the bomb
	if (timer <= 0){
		instance_create_depth(x, y, depth, obj_wallfire_proj1_explode);
		instance_destroy(self);	
	}
	// Make the bomb tick faster
	if (timer <= 30)
		image_speed = 3;	
}

// Call the basic movement scripts
scr_enemy_horizontal_movement();
scr_enemy_vertical_movement();

// Call the entity collision script
scr_entity_collision(false, true, false);