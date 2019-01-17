/// @description Basic up/down movement that is to be used by any enemy AI that needs to move up and down.

if (up){ // Upward movement
	vspd -= grav;
	if (vspd < -(maxVspd - vspdPenalty) || grav == 0){
		vspd = -(maxVspd - vspdPenalty);
	}
}
if (down){ // Downward movement
	vspd += grav;	
	if (vspd > maxVspd - vspdPenalty || grav == 0){
		vspd = maxVspd - vspdPenalty;	
	}
}