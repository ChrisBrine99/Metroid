/// @description Player Movement/Collision Handling
// You can write your code in this editor

#region Keyboard Input

var keyRight, keyLeft, keyJump, keyStopJump, keyUp, keyDown, keyShoot, keyQuickMenu;
keyRight = keyboard_check(global.gKey[KEY.GAME_RIGHT]);				
keyLeft = keyboard_check(global.gKey[KEY.GAME_LEFT]);					
keyJump = keyboard_check_pressed(global.gKey[KEY.JUMP]);			
keyStopJump = keyboard_check_released(global.gKey[KEY.JUMP]);	
keyUp = keyboard_check(global.gKey[KEY.GAME_UP]);						
keyDown = keyboard_check(global.gKey[KEY.GAME_DOWN]);					
keyShoot = keyboard_check_pressed(global.gKey[KEY.USE_WEAPON]);		
keyQuickMenu = keyboard_check(global.gKey[KEY.SWAP_WEAPON]);

#endregion

#region When the Player Is Idle or Cannot Move

// Stop the player from updating if they cannot move
if (!canMove){
	return;	
}

if (!hasStarted){
	if (keyRight || keyLeft){
		if (!audio_is_playing(music_samus_appears)){
			hasStarted  = true;	
			with(obj_controller) {playMusic = true;}
		}
	}
	return;	
}

#endregion

#region Gravity and Jumping Logic

// Calling the gravity script
scr_entity_gravity();

// Setting the player's state based on if they are on or off the ground
if (onGround){
	// Stopping Samus from getting stuck in the ground
	if (mask_index == spr_jumping_mask){
		if (gravDir == 270) {y -= 8;}
		else {y += 8;}
		mask_index = spr_standing_mask;
		// Make the impact more noticable by stopping Samus when she touches the ground
		if (keyRight || keyLeft) {hspd = 0;}
		// Set Samus's somersaulting and aiming down variables to false
		jumpspin = false;
		down = false;
		// Reset Samus's vertical speed
		vspd = 0;
		// Stop the screw attack sound effect
		if (audio_is_playing(snd_samus_screw_attack)){
			audio_stop_sound(snd_samus_screw_attack);	
		}
		// Play a landing sound effect
		scr_play_sound(snd_samus_land, 0, false, true);
	} 
	if (inMorphball){ // Making the morphball bounce
		if (vspdRecoil < 0){
			vspd = vspdRecoil;
			hspd = sign(hspd);
		} else{ // Reset the variable used for bomb jumping
			jumpspin = false;
		}
	} else{
		// Playing the Footstep Sound Effect
		if (hspd > 0.5 || hspd < -0.5){
			footstepTimer = scr_update_value_delta(footstepTimer, -1);
			if (footstepTimer <= 0){
				// Play the sound, but vary its pitch and volume
				var sound, gain, pitch;
				sound = audio_play_sound(snd_samus_walk, 0, false);
				gain = 1 - random(0.5);
				pitch = 1 + choose(random(0.1), -random(0.1));
				// Inject the altered pitch and volume into the sound
				audio_sound_pitch(sound, pitch);
				audio_sound_gain(sound, scr_volume_type(snd_samus_walk) * gain, 0);
				// Reset the timer
				footstepTimer = footstepTimerMax;
			}
		} else{ // Stopping the Footstop sound effect
			if (audio_is_playing(snd_samus_walk)){
				audio_stop_sound(snd_samus_walk);
			}
			footstepTimer = 0;
		}
		footstepTimerMax = 12;
	}
} else{ // Calculating how far the morphball will bounce
	if (inMorphball){
		if (vspd > 2){
			vspdRecoil = -(vspd / 2);
		} else{
			vspdRecoil = 0;	
		}
	}
}

// Handling jumping
if (keyJump){
	if (!inMorphball){
		// Only allow the player to jump if they aren't standing right beneath a block
		if (!place_meeting(x, y - 1, par_block)){
			if (onGround){
				vspd = lengthdir_y(jumpSpd + (vspdPenalty / 2), gravDir);
				onGround = false;
				crouching = false;
				hasPressedDown = false;
				// Setting the subState to somersaulting if the player is moving before they jump
				if (!isShooting){
					if ((hspd >= 1 || hspd <= -1) && !up && !down){
						jumpspin = true;
						// Create the jump effect object
						instance_create_depth(x, y, depth, obj_jumpspin_effect);
					}
				}
				if (jumpspin && global.item[ITEM.SCREW_ATTACK]){ // Play the screw attack jump sound
					scr_play_sound(snd_samus_screw_attack, 0, false, true);
				} else{ // Play the normal jump sound
					scr_play_sound(snd_samus_jump, 0, false, true);
				}
				// Stop the walking sound if it was still playing
				if (audio_is_playing(snd_samus_walk)){
					audio_stop_sound(snd_samus_walk);
				}
			} else{
				// Somersaulting while airbourne
				if (!jumpspin && !isShooting){
					jumpspin = true;
					hspd = sign(imgXScale);
					vspd = 0;
					// Create the jump effect object
					instance_create_depth(x, y, depth, obj_jumpspin_effect);
					// Play the screw attack jump sound
					if (global.item[ITEM.SCREW_ATTACK]){
						scr_play_sound(snd_samus_screw_attack, 0, false, true);
					}
				} else if (global.item[ITEM.SPACE_JUMP] && jumpspin){ // The Space Jump
					if (vspd >= 2.5){
						vspd = lengthdir_y(jumpSpd + (vspdPenalty / 2), gravDir);
						if (global.item[ITEM.SCREW_ATTACK]){ // Play the screw attack jump sound
							scr_play_sound(snd_samus_screw_attack, 0, false, true);
						} else{ // Play the normal jump sound
							scr_play_sound(snd_samus_jump, 0, false, true);
						}
					}
				}
			}
		}
	} else{ // The Spring Ball's jump
		if (onGround && global.item[ITEM.SPRING_BALL]){
			vspd = jumpSpd * 0.8;
		}
	}
}
// Allows for user-control of how high the player will jump
if (keyStopJump){
	if ((vspd < 0 && gravDir == 270) || (vspd > 0 && gravDir == 90)){
		vspd /= 2;	
	}
}

#endregion

#region Horizontal Movement

if (keyRight){
	if (!left){
		facingRight = true;
		// Reset the hspd if it is positive (Only when on the ground)
		if (hspd < 0 && onGround) {hspd = 0;}
	}
	// Smoothly accelerate (Half-speed while airbourne)
	if (onGround) {hspd = scr_update_value_delta(hspd, accel);}
	else {hspd = scr_update_value_delta(hspd, accel / 2);}
	// Prevent the horizontal speed from becoming too large
	if (hspd > maxHspd - hspdPenalty){
		hspd = (maxHspd - hspdPenalty);
	}
	right = true;
} else{ // The right key is no longer being pressed down
	right = false;	
}
// Moving to the left
if (keyLeft){
	if (!right){
		facingRight = false;
		// Reset the hspd if it is positive (Only when on the ground)
		if (hspd > 0 && onGround) {hspd = 0;}
	}
	// Smoothly accelerate (Half-speed while airbourne)
	if (onGround) {hspd = scr_update_value_delta(hspd, -accel);} 
	else {hspd = scr_update_value_delta(hspd, -accel / 2);}
	// Prevent the horizontal speed from becoming too large
	if (hspd < -(maxHspd - hspdPenalty)){
		hspd = -(maxHspd - hspdPenalty);
	}
	left = true;
} else{ // The left key is no longer being pressed down
	left = false;	
}
// Stopping horizontal movement
if ((keyRight && keyLeft) || (!keyRight && !keyLeft)){
	if (onGround || (!onGround && !jumpspin)){
		if (hspd < -accel){ // Slowing down while moving left
			hspd = scr_update_value_delta(hspd, accel);
		} else if (hspd > accel){ // Slowing down while moving right
			hspd = scr_update_value_delta(hspd, -accel);
		} else{
			// Setting a penalty for horizontal movement in the air
			if (!onGround) {hspdPenalty = 1;}
			hspd = 0;
		}
	}
}
// Stop Samus from moving while crouching
if (crouching){
	hspd = 0;
	// Decrement the timer for Samus to stand up when pressing either left or right
	if ((keyRight && !keyLeft) || (keyLeft && !keyRight)){
		standTimer = scr_update_value_delta(standTimer, -1);
		if (standTimer <= 0){
			standTimer = standTimerMax;
			crouching = false;
		}
	} else{
		// Reset the timer
		standTimer = standTimerMax;
	}
}

#endregion

#region Other Player Abilities (Crouching, Aiming Up and Down, etc.)

// Aiming Upward/Stnading Up/Exiting Morphball
if (keyUp && !down){
	if (!hasPressedUp){
		hasPressedUp = true;
		if (inMorphball){ // Exiting Morphball Mode
			if (!place_meeting(x, y - 8, par_block)){
				inMorphball = false;
				vspdRecoil = 0;
				if (!onGround) {vspd = 0;}
				else {crouching = true;}
				scr_play_sound(snd_samus_transform, 0, false, true);
				// Update the HUD to display the current non-bomb weapon
				with(obj_hud) {alarm[0] = 1;}
			}
		} else if (crouching){ // Standing Up
			if (!place_meeting(x, y - 8, par_block)){
				crouching = false;
			}
		} else{ // Aiming Upward
			jumpspin = false;
			up = true;	
		}
	}
} else{ // Aiming Forward once again
	hasPressedUp = false;
	up = false;
}

// Aiming Downward/Crouching/Entering Morphball
if (keyDown && !up){
	if (!hasPressedDown){
		hasPressedDown = true;
		if (onGround){
			if (!inMorphball && !crouching){ // Crouching
				crouching = true;
				scr_play_sound(snd_samus_crouch, 0, false, true);
			} else if (crouching && global.item[ITEM.MORPHBALL]){ // Entering Morphball
				crouching = false;
				inMorphball = true;
				scr_play_sound(snd_samus_transform, 0, false, true);
				with(obj_hud) {alarm[0] = 1;}
			}
		} else{ // Aiming Downward (Only while airbourne)
			jumpspin = false;
			down = true;	
		}
	}
} else{
	hasPressedDown = false;
	down = false;
}

// Firing Projectiles/Deploying Bombs
if (keyShoot){
	// Reset the shooting state and its timer
	isShooting = true;	
	shootStateTimer = 20;
	// Stop the player from Somersault if they are airbourne
	jumpspin = false;
	// Stop the screw attack sound effect
	if (audio_is_playing(snd_samus_screw_attack)){
		audio_stop_sound(snd_samus_screw_attack);	
	}
	// Actually spawning in the projectile/bomb
	if (!inMorphball){
		if (isWeaponUnlocked[curWeaponIndex]){
			if (fireRateTimer <= 0){
				var projectile, rndX, rndY;
				projectile[0] = noone;
				rndX = round(x);
				rndY = round(y);
				switch(curWeaponIndex){
					case 0: // Power Beam
						projectile[0] = instance_create_depth(rndX, rndY, 310, obj_powerbeam);
						// Resetting the fireRateTimer variable
						fireRateTimer = powerBeamFR;
						break;
					case 1: // Ice Beam
						projectile[0] = instance_create_depth(rndX, rndY, 310, obj_icebeam);
						// Resetting the fireRateTimer variable
						fireRateTimer = iceBeamFR;
						break;
					case 2: // Wave Beam
						projectile[0] = instance_create_depth(rndX, rndY, 310, obj_wavebeam);
						projectile[1] = instance_create_depth(rndX, rndY, 310, obj_wavebeam);
						projectile[1].movingUp = true;
						// Resetting the fireRateTimer variable
						fireRateTimer = waveBeamFR;
						break;
					case 3: // Spazer Beam
						projectile[0] = instance_create_depth(rndX, rndY, 310, obj_spazerbeam);
						projectile[1] = instance_create_depth(rndX, rndY, 310, obj_spazerbeam);
						projectile[1].increment = 0;
						projectile[2] = instance_create_depth(rndX, rndY, 310, obj_spazerbeam);
						projectile[2].movingUp = true;
						// Resetting the fireRateTimer variable
						fireRateTimer = spazerBeamFR;
						break;
					case 4: // Plasma Beam
						projectile[0] = instance_create_depth(rndX, rndY, 310, obj_plasmabeam);
						// Resetting the fireRateTimer variable
						fireRateTimer = plasmaBeamFR;
						break;
					case 5: // Missiles
						if (numMissiles > 0){
							projectile[0] = instance_create_depth(rndX, rndY, 310, obj_missile);
							// Resetting the fireRateTimer variable
							fireRateTimer = missileFR;
							// Remove a missile from Samus's ammo reserves
							numMissiles--;
							global.curAmmo--;
						}
						break;
					case 6: // Super Missiles
						if (numSMissiles > 0){
							projectile[0] = instance_create_depth(rndX, rndY, 310, obj_sMissile);
							// Resetting the fireRateTimer variable
							fireRateTimer = sMissileFR;
							// Remove a missile from Samus's ammo reserves
							numSMissiles--;
							global.curAmmo--;
						}
						break;
				}
				// Setting the offset of the projectile correctly (If one exists)
				var length, isUp, isDown, isCrouching, curHspd, curVspd, facing, isGrounded, imageXScale;
				length = array_length_1d(projectile);
				// Setting all referenced player states as local variables to speed up execution
				isUp = up;
				isDown = down;
				isCrouching = crouching;
				curHspd = hspd;
				curVspd = vspd;
				facing = facingRight;
				isGrounded = onGround;
				imageXScale = imgXScale;
				for (var i = 0; i < length; i++){
					if (projectile[i] != noone){
						with(projectile[i]){
							if (isGrounded){ // Firing on the Ground
								if (curHspd >= 1 || curHspd <= -1){ // Shooting while moving
									if (!isUp){ // Aiming Forward
										offsetX = 20 * sign(imageXScale);
										offsetY = -7;
									} else{ // Aiming Upward
										offsetX = 8 * sign(imageXScale);
										offsetY = -20;
									}
								} else{
									if (!isUp && !isCrouching){ // Aiming Forward
										offsetX = 10 * sign(imageXScale);
										offsetY = -3;
									} else if (isUp){ // Aiming Upward
										offsetX = 4 * sign(imageXScale);
										offsetY = -20;
									} else if (isCrouching){ // Crouching
										offsetX = 10 * sign(imageXScale);
										offsetY = 7;
									}
								}
							} else{ // Firing while Airbourne
								if (!isUp && !isDown){ // Aiming Forward
									offsetX = (12 + curHspd) * sign(imageXScale);
									offsetY = -1 + curVspd;
								} else if (isUp){ // Aiming Upward
									offsetX = (4 + curHspd) * sign(imageXScale);
									offsetY = -20 + curVspd;
								} else if (isDown){ // Aiming Downward
									offsetX = (5 + curHspd) * sign(imageXScale);
									offsetY = 14 + curVspd;
								}
							}
							// Setting the direction of the projectile
							if (!isUp && !isDown){
								if (facing) {right = true;}
								else {left = true;}
							} else{
								up = isUp;
								down = isDown;
							}
						}
					}
				}
			}
		}
	} else{
		if (isBombUnlocked[curBombIndex]){
			switch(curBombIndex){
				case 0: // Deploying a Normal Bomb
					if (instance_number(obj_bomb) < 3){ // A maximum number of 3 bombs can be on-screen at once
						instance_create_depth(x, y + 14, depth - 1, obj_bomb);
					}
					break;
				case 1: // Deploying a Power Bomb
					if (numPBombs > 0){
						if (!instance_exists(obj_pBomb)){ // A maximum number of one power bomb can be on-screen at once
							instance_create_depth(x, y + 14, depth - 1, obj_pBomb);
							numPBombs--;
							global.curAmmo--;
						}
					}
					break;
			}
		}
	}
}
// Counting doen the fire rate timer
if (fireRateTimer > 0){
	fireRateTimer = scr_update_value_delta(fireRateTimer, -1);
}
// Counting down the timer that prevents the player from 
if (isShooting){
	shootStateTimer = scr_update_value_delta(shootStateTimer, -1);
	if (shootStateTimer <= 0){
		isShooting = false;
		shootStateTimer = 20;
	}
}

// Open up the Quick Menu
if (keyQuickMenu){
	if (!instance_exists(obj_weapon_menu)){
		instance_create_depth(0, 0, 10, obj_weapon_menu);
	}
}

#endregion

#region Handling Collision with the World and its' Hazards and Enemies

// Setting the player's collision box
if (onGround){
	if (!crouching && !inMorphball){
		mask_index = spr_standing_mask;
	} else if (crouching && !inMorphball){
		mask_index = spr_crouching_mask;
	} else if (inMorphball){
		mask_index = spr_morphball_mask;	
	}
} else{
	if (!inMorphball){
		mask_index = spr_jumping_mask;
	}
}

// Colliding with the Bomb Explosion to allow it to launch the user while in morphball mode
if (inMorphball){
	if (instance_exists(obj_bomb_explode)){
		var bomb = instance_nearest(x, y, obj_bomb_explode);
		// Make sure the player isn't below the bomb explosion
		if (bomb.y > y + 8){
			if (place_meeting(x, y, bomb)){
				vspd = -3;
				if (x < bomb.x - 3){
					jumpspin = true;
					hspd = -60;
				} else if (x >= bomb.x + 3){
					jumpspin = true;
					hspd = 60;	
				}
			}
		}
	}
}

// Handling Collisions between the player and objects likes warps, hazards, enemies, and event triggers
var object = instance_place(x, y, obj_collider_object);
if (object != noone){
	with(object){
		switch(colliderType){
			case COLLIDER.WARP: // Colliding with a room warp
				isWarping = true;
				fadeID = instance_create_depth(0, 0, 45, obj_fade_transition);
				// Set up the warp to create the sprite sweeping transition
				with(fadeID){
					// Set up the sprite sweep to use the Player's current sprite and position
					effectID = instance_create_depth(obj_player.x - global.camX, obj_player.y - global.camY, 40, obj_sprite_sweep_transition);
					with(effectID){
						fadeID = object.fadeID;
						curRoom = room;
						// Starting coordinates
						startXPos = x;
						startYPos = y;
						// Set the transition speed
						transitionSpd = 5;
						// The sprite parameters being passed on from the Player to this
						playerSpr = obj_player.sprite_index;
						curImg = obj_player.imgIndex;
						imgXScale = sign(obj_player.imgXScale);
						imgYScale = sign(obj_player.imgYScale);
					}
					// Alter the opaque time to 0.5 seconds
					opaqueTime = 30;
				}
				break;
			case COLLIDER.LIQUID: // Colliding with Water, Lava, or Acid
				// Only slow the player down if they do not have the gravity suit
				if (global.item[ITEM.GRAVITY_SUIT] == false){
					with(other){
						// Slow down the Player and the footstep sound's speed
						if (hspd > 1 || hspd < -1) {hspd = sign(hspd);}	
						footstepTimerMax = 18;
						// Make the player's jump height very low
						if (!onGround){
							if (vspd < 0) {vspd = scr_update_value_delta(vspd, -(vspd * 0.08));}
							else {vspd = scr_update_value_delta(vspd, -grav / 2);}
						}
					}
				}
				// Don't take away damage if the object isn't damaging (Ex. Water)
				if (damage > 0){
					dmgTimer = scr_update_value_delta(dmgTimer, -1);
					// Deal out damage to the Player
					if (dmgTimer <= 0){
						var dmg = damage;
						dmgTimer = dmgTimerMax;
						with(other) {scr_update_hitpoints(-round(dmg * damageRes));}
						scr_play_sound(snd_samus_drown, 0, false, true);
					}
				}
				break;
		}
	}
}

// Calling the Entity Collision script
scr_entity_collision(hspd, vspd, onGround, gravDir, true, true, false);

// Colliding with a fall-through floor
if (place_meeting(x, y + 1, obj_dblock_fall_through)){
	var block = instance_place(x, y + 1, obj_dblock_fall_through);
	with(block){
		if (!isDestroyed){
			isDestroyed = true;
			destroyTimer = destroyTimerMax;
			// Create the block destroying effect
			instance_create_depth(x, y, depth, obj_dblock_destroy);
		}
	}
}

#endregion

#region Editing Samus's Ambient Light source

if (ambLight != noone){
	// Altering the position and size of the ambient light
	if (onGround){
		if (inMorphball){
			yOffset = 12;
		} else if (crouching){
			yOffset = 8;	
		} else{
			yOffset = 0;	
		}
		// Setting the ambient light's size and color as their default values
		with(ambLight){
			xRad = 35;
			yRad = 35;
			lightCol = c_ltgray;
		}	
	} else{
		if (!inMorphball){
			// Creating a crazy electrical flashing effect for the screw attack
			if (global.item[ITEM.SCREW_ATTACK]){
				flashingTime = scr_update_value_delta(flashingTime, -1);
				var fTime, jmpSpin;
				fTime = flashingTime;
				jmpSpin = jumpspin;
				with(ambLight){
					if (jmpSpin){
						if (fTime <= 0){
							xRad = choose(75, 80, 85);
							yRad = xRad;
							lightCol = choose(c_aqua, c_lime, c_white);
							other.flashingTime = 1;	
						}
					} else{
						xRad = 35;
						yRad = 35;
						lightCol = c_ltgray;	
					}
				}
			}
		}
	}
}

#endregion