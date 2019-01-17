/// @description Checking for collision between the entity and projectiles/bombs
// You can write your code in this editor

// If the enemy is a enemy's projectile, don't bother checking for collision
if (hitpoints = noone)
	return;

// Check if the pause menu has been opened
if (instance_exists(obj_pause_menu) || global.itemCollected || x <= global.camX - buffer || x >= global.camX + global.camWidth + buffer || y <= global.camY - buffer || y >= global.camY + global.camHeight + buffer){
	canMove = false;
	exit;
}
else{
	canMove = true;	
}

// Colliison with regular bombs
if (instance_exists(obj_bomb_explode)){
	var bomb = instance_nearest(x, y, obj_bomb_explode);
	if (place_meeting(x, y, bomb)){
		if (!hit && weakToBombs){
			hit = true;
			hitpoints -= 2;	
		}
	}
}
// Collision with a power bomb
if (instance_exists(obj_pBomb_explode)){
	var pBomb = instance_nearest(x, y, obj_pBomb_explode);
	if (place_meeting(x, y, obj_pBomb_explode)){
		if (!hit){
			hit = true;
			hitpoints -= 50;
		}
	}
}

// Give the enemy very brief invincibility
if (hit){
	if (timer == 5){
		audio_play_sound(snd_enemy_hit, 0, false);
	}
	timer--;
	if (timer <= 0){
		timer = 5;
		hit = false;
	}
}
// Check if the entity's hp has dropped below 0
if (hitpoints <= 0 && hitpoints != -255){
	instance_destroy(self);
}

if (frozen){
	hspd = 0;
	vspd = 0;
	image_speed = 0;
	// Create the block for the player to stand on
	/*if (block == 0){
		block = instance_create_depth(x - (sprite_width / 2), y + 3, depth, obj_block);
		block.image_xscale = self.sprite_width / block.sprite_width;
		block.image_yscale = (self.sprite_height - 6) / block.sprite_height;
		block.direction = self.direction;
		block.type = 1;
		// Make sure the block isn't colliding with the player
		with(block){
			if (place_meeting(x, y, obj_samus)){
				instance_destroy(self);	
			}
		}
	}*/
	// The timer until the enemy unfreezes
	frozenTimer--;
	if (frozenTimer <= 0){
		frozenTimer = 600;
		frozen = false;
	}
	exit;
}
else{
	image_speed = 1;
	// Destroy the block when the enemy unfreezes
	/*if (block != 0){
		instance_destroy(block);
		block = 0;
	}*/
}