/// @description Updates the position of an entity that is classified as a projectile. (Ex. They are children of
/// the object "par_entity_projectile") Gravity isn't applied to the object and instead 8-directional movement
/// is calculated; with acceleration if acceleration's on the x or y axis aren't set to 0, respectively.

function update_position_projectile(){
	// Horizontal Movement
	if (accel == 0){ // No acceleration; instantly set to maximum speed
		hspd = maxHspd * inputDirection[X];
	} else{ // Acceleration; slowly approach maximum speed in either direction
		hspd += accel * inputDirection[X];
		if (hspd < -maxHspd || hspd > maxHspd){
			hspd = maxHspd * inputDirection[X];
		}
	}

	// Vertical Movement
	if (grav == 0){ // No acceleration; instantly set to maximum speed
		vspd = maxVspd * inputDirection[Y];
	} else{ // Acceleration; slowly approach maximum speed in either direction
		vspd += grav * inputDirection[Y];
		if (vspd < -maxVspd || vspd > maxVspd){
			vspd = maxVspd * inputDirection[Y];
		}
	}
}