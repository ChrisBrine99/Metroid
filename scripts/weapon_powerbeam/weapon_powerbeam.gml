/// @description The function that calls whenever the player presses the shoot button and has the powerbeam
/// currently equipped. It fires a single low-damage projectile out of the arm cannon.
/// @param xOffset
/// @param yOffset

function weapon_powerbeam(_xOffset, _yOffset){
	var _aimDirection = aimDirection;
	with(instance_create_depth(x + (image_xscale * _xOffset), y + _yOffset, ENTITY_DEPTH, obj_power_beam)){
		image_index = (_aimDirection == AIM_UPWARD || _aimDirection == AIM_DOWNWARD);
		inputDirection = samus_get_aim_direction(_aimDirection, other.image_xscale);
	}
}