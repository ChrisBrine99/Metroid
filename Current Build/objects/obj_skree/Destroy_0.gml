/// @description Shoot out projectiles
// You can write your code in this editor

// Creating the explosion for the skree
if (hitpoints > 0){
	var proj;
	for (var i = 0; i < 4; i++){
		proj[i] = instance_create_depth(x, y + (sprite_height / 2), depth, obj_skree_proj);
		proj[i].damage = self.damage;
	}
	// Top right projectile velocity
	proj[0].hspd = 6;
	proj[0].vspd = -6;
	// Top left projectile velocity
	proj[1].hspd = -6;
	proj[1].vspd = -6;
	// Right projectile velocity
	proj[2].hspd = 6;
	proj[2].vspd = 0;
	// Left projectile velocity
	proj[3].hspd = -6;
	proj[3].vspd = 0;
}

// Call the parent's destroy event
event_inherited();