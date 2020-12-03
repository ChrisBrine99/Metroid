/// @description These functions are all involved with Samus using her currently equipped weapon, which can be
/// the power, wave, ice, spazer, and plasma beams; the missile and super missile launcher; the bombs and
/// power bombs.

/// @description The function that calls whenever the player presses the shoot button and has the powerbeam
/// currently equipped. It fires a single low-damage projectile out of the arm cannon.
/// @param xOffset
/// @param yOffset
function weapon_powerbeam(_xOffset, _yOffset){
	var _aimDirection = aimDirection;
	with(instance_create_depth(x + (image_xscale * _xOffset), y + _yOffset, ENTITY_DEPTH, obj_samus_projectile)){
		sprite_index = spr_power_beam;
		// Determines the direction and velocity for the projectile
		image_index = (_aimDirection == AIM_UPWARD || _aimDirection == AIM_DOWNWARD);
		inputDirection = samus_get_aim_direction(_aimDirection, other.image_xscale);
		// Set the maximum speeds both axes
		set_max_move_speed(9, 9, true);
		// Set the damage of the power beam
		damage = 1;
		// The power beam will be destroyed by both entities and walls
		destroyOnWallCollide = true;
		destroyOnEntityCollide = true;
		// Finally, this projectile was fired by Samus, so it won't hurt her
		projectileType = Weapon.PowerBeam;
	}
}

/// @description The function that is called whenever the player presses the shoot button while Samus has the
/// icebeam equipped. It fires a single low-damage projectile that can freeze weaker enemies on contact.
/// @param xOffset
/// @param yOffset
function weapon_icebeam(_xOffset, _yOffset){
	
}

/// @description The function that calls whenever the player presses the shoot button while the wavebeam is
/// equipped by Samus. It fires two mid-damage projectiles that move in a wave-like pattern; hence the name
/// of the weapon. The wavebeam can move through solid walls.
/// @param xOffset
/// @param yOffset
function weapon_wavebeam(_xOffset, _yOffset){
	
}

/// @description The function that is called whenever the player presses the shoot button while the spazerbeam
/// is equipped by Samus. It fires three high-damage projectile; two in a wave-like patten, and one that shoots
/// in a straight path. The waves have a higher amplitude compared to the wavebeam, and the spazerbeam can also
/// shoot through solid objects.
/// @param xOffset
/// @param yOffset
function weapon_spazerbeam(_xOffset, _yOffset){
	
}

/// @description The function that calls whenever the player presses the shoot button while Samus has the 
/// plasmabeam equipped. It fires two extremely powerful beams that spread out slightly before stopping and
/// moving in a straight path. These projectiles can move through solid objects AND anything else; including
/// any enemies it comes into contant with.
/// @param xOffset
/// @param yOffset
function weapon_plasmabeam(_xOffset, _yOffset){
	
}

/// @description The function that is called whenever the player presses the shoot button while the missiles
/// are equipped by Samus. It fires a single high-damage projectile that accelerates to full speed at a decent
/// rate. It can be used to destroy certain destrcutible blocks.
/// @param xOffset
/// @param yOffset
function weapon_missile(_xOffset, _yOffset){
	
}

/// @description The function that calls whenever the player presses the shoot button while Samus has her
/// Super Missiles equipped. It fires a single extremely powerful projectile that moves at a slightly slower
/// speed than the standard missile. It can be used to destroyed certain destructible blocks.
/// @param xOffset
/// @param yOffset
function weapon_super_missile(_xOffset, _yOffset){
	
}

/// @description The function that is called whenever the player presses the shoot button while Samus is in 
/// morphball mode AND she has the standard bombs equipped. It sets a single, low-damage bomb that explodes
/// after around half a seonc to one second of real-time. It can be used to destroy certain destructible
/// blocks AND can also launch Samus into the air while she's in her morphball mode.
/// @param xOffset
/// @param yOffset
function weapon_bomb(_xOffset, _yOffset){
	
}

/// @description The function that calls whenever the player presses the shoot button while Samus is in
/// morphball mode AND has the power bombs equipped. It sets a single, lethal-damage bomb that detonates into
/// a MASSIVE explosion that fills the screen; decimating almost anything caught in the blast. It can be used
/// to destroy certain destructible blocks.
function weapon_power_bomb(_xOffset, _yOffset){
	
}