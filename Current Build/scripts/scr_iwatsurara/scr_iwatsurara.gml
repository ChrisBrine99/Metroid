/// @description Very basic AI that crawls through a block and falls once free from any blocks. Once it 
/// hits the ground it will dig back into the soil and disappear.

// Call the parent's step event
event_inherited();

if (!canMove || frozen){
	return;
}

// Vertical Collision
if (place_meeting(x, y + 1, par_block)){ // Digging through the ground
	vspd = 0.3;
	if (isFalling){
		despawnTimer--;
		if (despawnTimer <= 0){
			invulnerable = true;
			instance_destroy(self);	
		}
	}
}
else{ // Falling
	isFalling = true;
	vspd += grav;
	if (vspd > maxVspd){
		vspd = maxVspd;
	}
}
y += vspd;