/// @description Creating a Wave-Motion on the Projectile
// You can write your code in this editor

if (increment != 0){
	if (up || down){ // Producing horizontal waves
		if (movingUp) hspd = scr_update_value_delta(hspd, increment);
		else hspd = scr_update_value_delta(hspd, -increment);
		// Switching Directions
		if (hspd >= maxAmplitude || hspd <= -maxAmplitude){
			movingUp = !movingUp;
			hspd = maxAmplitude * sign(hspd);
		}
	} else if (right || left){ // Producing vertical waves
		if (movingUp) vspd = scr_update_value_delta(vspd, -increment);
		else vspd = scr_update_value_delta(vspd, increment);
		// Switching Directions
		if (vspd >= maxAmplitude || vspd <= -maxAmplitude){
			movingUp = !movingUp;
			vspd = maxAmplitude * sign(vspd);
		}	
	}
}