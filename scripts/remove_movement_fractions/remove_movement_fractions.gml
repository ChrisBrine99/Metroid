/// @description Removes and stores away the decimal values for the entity's current hspd and vspd. This ensures 
/// that the entity will never move on a sub-pixel basis, which makes collision a lot more simplified.

function remove_movement_fractions(){
	if (hspd == 0){
		hspdFraction = 0;
	}
	// Recalculate the remaining fractional value for horizontal movement
	deltaHspd += hspdFraction;
	hspdFraction = deltaHspd - (floor(abs(deltaHspd)) * sign(deltaHspd));
	deltaHspd -= hspdFraction;

	if (vspd == 0){
		vspdFraction = 0;
	}
	// Recalculate the remaining fractional value for vertical movement
	deltaVspd += vspdFraction;
	vspdFraction = deltaVspd - (floor(abs(deltaVspd)) * sign(deltaVspd));
	deltaVspd -= vspdFraction;
}