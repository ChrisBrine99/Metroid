// Don't bother updating the moving collider's position if the current game state isn't "normal" (Ex. In a menu,
// completely paused, etc.).
if (GAME_CURRENT_STATE != GSTATE_NORMAL)
	return;

// Moving the collider along the x axis so long as its "hspd" is set to a value other than zero. It works by 
// taking the previous fraction--adding it to the new "hspd * DELTA_TIME" value--before removing it alongside 
// any new fraction that may have appeared through that delta timing calculation. Then the whole value remainder 
// is added to the collider's current x position.
if (hspd != 0.0){
	deltaHspd		= (hspd * DELTA_TIME) + hspdFraction;
	hspdFraction	= deltaHspd - (floor(abs(deltaHspd)) * sign(deltaHspd));
	deltaHspd	   -= hspdFraction;
	x			   += deltaHspd;
}

// Moving the collider along the y axis so long as its "vspd" is set to a value other than zero. It goes through
// all the same steps as the code for moving the collider along the x axis to remove any fractional values before
// adding the remaining whole value to the y axis.
if (vspd != 0.0){
	deltaVspd		= (vspd * DELTA_TIME) + vspdFraction;
	vspdFraction	= deltaVspd - (floor(abs(deltaVspd)) * sign(deltaVspd));
	deltaVspd	   -= vspdFraction;
	y			   += deltaVspd;
}