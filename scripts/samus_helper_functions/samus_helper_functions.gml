/// @description Functions that assist Samus with certain states and other functions. These include, but are not
/// limited to, getting a 2D vector based on Samus's current aiming direction, which is then used to help
/// determine the direction of a projectile that is spawned.

/// @description Gets the 2D vector related to Samus's current aiming direction. It will determine how the 
/// projectile moves after creation.
/// @param aimDirection
/// @param image_xscale
function samus_get_aim_direction(_aimDirection, _imageXScale) {
	switch(_aimDirection){
		case AIM_FORWARD: // Vectors for left/right movement [1, 0] or [-1, 0]
			return _imageXScale == 1 ? MOVE_RIGHT : MOVE_LEFT;
		case AIM_UPWARD: // Vector for upward movement [0, -1]
			return MOVE_UP;
		case AIM_DOWNWARD: // Vector for downward movement [0, 1]
			return MOVE_DOWN;
	}
}