/// @description These functions are all involved with Samus using her currently equipped weapon, which can be
/// the power, wave, ice, spazer, and plasma beams; the missile and super missile launcher; the bombs and
/// power bombs.

/// @description The function that is called whenever Samus fires a projectile out of her arm cannon. This
/// means that code for dropping a bomb is handled outside of this function.
function samus_use_arm_cannon(_canUseWeapon){
	// The weapon cannot be used in the current state OR an invalid script is set, exit the function early.
	if (!_canUseWeapon || ds_list_find_value(cannonScripts, curBeam) == undefined){
		return;
	}
	// Changes the animation for Samus's forward walk for the duration of this flag being set to true.
	// Also, stops her from somersaulting in mid-air.
	isShooting = true;
	shootTimer = 0;
	// Don't try creating a weapon projectile if no script exists to create it.
	var _weaponOffset = [0, 0];
	if (isGrounded){ // The weapon spawn offset when Samus is on the ground
		if (curState == state_samus_crouch){
			_weaponOffset[X] = 11;
			_weaponOffset[Y] = 7;
		} else{
			if (hspd > -1 && hspd < 1){ // Samus is standing still; aiming forward or upward, respectively.
				var _offsets = [12, -3, 3, -22];
				_weaponOffset[X] = _offsets[aimDirection * 2];
				_weaponOffset[Y] = _offsets[(aimDirection * 2) + 1];
			} else{ // Samus is walking; aiming forward or upward, respectively.
				var _offsets = [17, -7, 17, -6, 17, -7, 4, -23, 4, -22, 4, -23];
				_weaponOffset[X] = _offsets[(aimDirection * 6) + (floor(curFrame) * 2)];
				_weaponOffset[Y] = _offsets[(aimDirection * 6) + (floor(curFrame) * 2) + 1];
			}
		}
	} else{ // The weapon spawn offset whenever Samus is airbourne
		var _offsets = [13, -1, 4, -22, 5, 9];
		_weaponOffset[X] = _offsets[aimDirection * 2];
		_weaponOffset[Y] = _offsets[(aimDirection * 2) + 1];
	}
	// Spawn the weapon using its associated script at the given offset
	script_execute(cannonScripts[| curBeam], _weaponOffset[X], _weaponOffset[Y]);
}

function samus_deploy_bomb(_canUseWeapon){
	// The weapon cannot be used in the current state OR an invalid script is set, exit the function early.
	if (!_canUseWeapon || ds_list_find_value(bombScripts, curBomb) == undefined){
		return;
	}
	// No offsets are calculated for deploying bombs, just call its script
	script_execute(bombScripts[| curBomb], 0, 12);
}

/// @description The function that calls whenever the player presses the shoot button and has the powerbeam
/// currently equipped. It fires a single low-damage projectile out of the arm cannon.
/// @param xOffset
/// @param yOffset
function weapon_powerbeam(_xOffset, _yOffset){
	var _aimDirection = aimDirection;
	with(instance_create_depth(x + (image_xscale * _xOffset), y + _yOffset, ENTITY_DEPTH, obj_samus_projectile)){
		sprite_index = spr_power_beam;
		// Create the ambient lighting for the power beam
		entity_create_light(0, 0, 15, 15, 1, c_orange);
		// Determines the direction and velocity for the projectile
		curFrame = (_aimDirection == AIM_UPWARD || _aimDirection == AIM_DOWNWARD);
		inputDirection = samus_get_aim_direction(_aimDirection, other.image_xscale);
		// Set the maximum speeds both axes
		set_max_move_speed(9, 9, true);
		// Set the damage of the power beam
		damage = 1;
		// The power beam will be destroyed by entities AND walls
		destroyOnEntityCollide = true;
		destroyOnWallCollide = true;
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
/// after around half a second to one second of real-time. It can be used to destroy certain destructible
/// blocks AND can also launch Samus into the air while she's in her morphball mode.
/// @param xOffset
/// @param yOffset
function weapon_bomb(_xOffset, _yOffset){
	// Before deploying a bomb, check if there are less than 3 currently in existence
	var _numBombs = 0;
	with(obj_samus_projectile){
		_numBombs += (projectileType == Weapon.Bomb);
		if (_numBombs >= 3){
			return;
		}
	}
	// If less than three standard bombs currently exists, spawn another one
	with(instance_create_depth(x + (image_xscale * _xOffset), y + _yOffset, ENTITY_DEPTH, obj_samus_projectile)){
		sprite_index = spr_bomb;
		// Create the ambient lighting for the bomb
		entity_create_light(0, 0, 12, 12, 1, make_color_rgb(125, 125, 255));
		// Bombs detonate after a short period of time; set their lifespan accordingly
		lifespan = 60;
		// Assign the function that is called when the bomb explodes
		destroyScript = samus_bomb_explode;
		// Set the damage of the bomb
		damage = 2;
		// Finally, enable the bomb to animate
		projectileAnimates = true;
		spriteSpeed = sprite_get_speed(sprite_index);
		spriteNumber = sprite_get_number(sprite_index);
		// Finally, set the type of the projectile to a bomb and disable any collision checks
		projectileType = Weapon.Bomb;
		ignoreCollision = true;
	}
}

/// @description The function that calls whenever the player presses the shoot button while Samus is in
/// morphball mode AND has the power bombs equipped. It sets a single, lethal-damage bomb that detonates into
/// a MASSIVE explosion that fills the screen; decimating almost anything caught in the blast. It can be used
/// to destroy certain destructible blocks.
function weapon_power_bomb(_xOffset, _yOffset){
	
}