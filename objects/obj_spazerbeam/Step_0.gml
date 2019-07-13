/// @description The Unique "Wave" Movement
// You can write your code in this editor

if (increment != 0){
	if (up || down){ // Producing horizontal waves
		if (movingUp) hspd += increment;
		else hspd -= increment;
		// Switching Directions
		if (hspd >= maxAmplitude || hspd <= -maxAmplitude){
			movingUp = !movingUp;
		}
	} else if (right || left){ // Producing vertical waves
		if (movingUp) vspd -= increment;
		else vspd += increment;
		// Switching Directions
		if (vspd >= maxAmplitude || vspd <= -maxAmplitude){
			movingUp = !movingUp;
		}	
	}
}

// Call the parent's step event
event_inherited();