#region	Initializing any macros that are useful/related to obj_player_hud

// Determines how fast the displayed energy and energy tanks on the HUD approaches the CURRENT value of energy
// Samus has within the game's actual data. Allows a sort of animation of incrementing/decrementing whenever
// her energy is altered.
#macro	ENERGY_INCREMENT_SPEED	0.08

// Much like the energy increment macro, this macro determines the speed of the displayed missile's ammo value
// incrementing/decrementing towards its true value stored in the player object.
#macro	MISSILE_INCREMENT_SPEED 0.15

// Determines the characteristics of the aeion gauge that is displayed on the game's HUD after the player gains
// access to an aeion ability. It determines the width of the bar, as well as how fast it fills/empties to
// match the actual value in the game's data.
#macro	AEION_GUAGE_WIDTH		46
#macro	AEION_GAUGE_FILL_SPEED	0.3

#endregion

#region Initializing enumerators that are useful/related to obj_player_hud
#endregion

#region Initializing any globals that are useful/related to obj_player_hud
#endregion

#region The main object code for obj_player_hud

/// @param {Real} index		Unique value generated by GML during compilation that represents this struct asset.
function obj_game_hud(_index) : base_struct(_index) constructor{
	// Controls the opacity level for the ENTIRE in-game HUD, and it can be dynamically changed by setting
	// the "alphaTarget" variables to different values between 0.0 and 1.0.
	alpha			= 1.0;
	alphaTarget		= 1.0;
	
	// Stores the values for the aeion gauge's glowing animation, which is processed inside the player object
	// using local variables. Without these, the local values would be lost and endless reset to their initial
	// values instead of actually performing the glowing pulse animation.
	glowStrength	= 0.0;
	glowTarget		= 1.0;
	
	// Variables for the HUD's various numerical values that are displayed. They are stored in separate values
	// from the player object's actual variables in order to allow animations that will increment and decrement
	// said values at a specific speed--independent of what the actual value in the data currently is.
	pCurEnergy		= 0.0;
	pCurMissiles	= 0.0;
	pCurAeion		= 0.0;
	
	/// @description Functions identically to how the "Draw GUI" event works within a GML object, so it should
	/// be called in such event of the object that manages the game hud insteance. In short, it calls functions 
	/// that will draw each part of the HUD; the player information, equipped and available beam information, 
	/// minimap, and so on.
	draw_gui = function(){
		alpha = value_set_linear(alpha, alphaTarget, 0.1);
		if (alpha == 0.0) {return;} // Ignore processing any HUD element if it's completely invisible.
		
		draw_player_info(2, 2, alpha);
	}
	
	/// @description Displays the player's current energy along with their current energy tank sum--whether
	/// they are currently filled or empty. Also, the ammunition reserve for Samus's missiles and power bombs
	/// are also dispayed using this function. Her aeion gauge is also shown if she has access to it.
	/// @param {Real}	xPos	Starting x offset that all player info is displayed with regards to.
	/// @param {Real}	yPos	Starting y offset that all player info is displayed with regard to.
	/// @param {Real}	alpha	The overall visibility of player information displayed on the HUD.
	draw_player_info = function(_xPos, _yPos, _alpha){
		var _glowStrength	= glowStrength;
		var _glowTarget		= glowTarget;
		var _pCurEnergy		= round(pCurEnergy);
		var _pCurMissiles	= round(pCurMissiles);
		var _pCurAeion		= round(pCurAeion);
		var _curEnergy		= 0;
		var _curMissiles	= 0;
		var _curAeion		= 0;
		with(PLAYER){
			// Display the total energy the player currently has; ignoring any additions added by energy tanks
			// they may have picked up. Instead of using a font, two images are drawn for each numbers place; the
			// values in those places determined by the formulas in the "subimage" argument.
			var _energy = _pCurEnergy % 100;
			if (_pCurEnergy > 30)	{draw_number_as_sprite(_xPos, _yPos, _energy, spr_energy_numbers, c_white, 2, 0, 1, _alpha);}
			else					{draw_number_as_sprite(_xPos, _yPos, _energy, spr_energy_numbers, HEX_DARK_RED, 2, 0, 1, _alpha);}
			
			// Display Samus' current energy tanks; both depleted and full onto the screen next to her current energy
			// value that displays the 00-99 in between each energy tank level. There are two rows of tanks that each
			// show six for a total of 12 energy tanks available in-game.
			var _energyTanks = floor(_pCurEnergy * 0.01);
			var _maxEnergyTanks = floor(maxHitpoints * 0.01);
			var _xx = _xPos + 21; // Each number is 10 pixels wide; times two; plus the one pixel gap between number value and tank icons.
			var _yy = (_maxEnergyTanks <= 6) ? _yPos + 3 : _yPos; // Adds three pixels to offset to center energy tank icons if there are less than seven total.
			for (var i = 0; i < _maxEnergyTanks; i++){
				draw_sprite_ext(spr_energy_tanks, (i < _energyTanks), 
					_xx + ((i % 6) * 6), _yy, 1, 1, 0, c_white, _alpha);
				if (i == 5) {_yy = _yPos + 6;} // Shifts the remaining icons after the first six down to their own row. 
			}
			
			// First, the missiles and their current amount of available ammunition are drawn. The icon is displayed
			// followed by the remaining ammo; changing color between white, red, and green depending on if the ammo
			// has ammo, is in use, or is out of ammo, respectively.
			var _xOffset = (_maxEnergyTanks < 6) ? _xx + (_maxEnergyTanks * 6) + 2 : _xx + 38;
			var _yOffset = _yPos + 2;
			if (event_get_flag(FLAG_MISSILES) && maxMissiles > 0){
				var _textColor = c_white;
				var _iconColor = c_white;
				if (curWeapon == curMissile){ // Highlight colors when missiles are being utilized.
					_textColor = HEX_LIGHT_GREEN;
					_iconColor = HEX_LIGHT_GREEN;
				} else if (_pCurMissiles == maxMissiles){ // Highlight colors when missile ammo is maximized.
					_textColor = HEX_LIGHT_YELLOW;
					// Icon color remains unchanged by this condition.
				}
				
				// Highlight colors when no missile ammo remains.
				if (_pCurMissiles == 0){
					_textColor = HEX_DARK_RED;
					_iconColor = HEX_GRAY;
				}
				
				draw_sprite_ext(spr_missile_icon, 0, _xOffset, _yOffset - 1, 1, 1, 0, _iconColor, _alpha);
				_xOffset += sprite_get_width(spr_missile_icon);
				_xOffset += draw_number_as_sprite(_xOffset, _yOffset, _pCurMissiles, spr_ammo_numbers, _textColor, 3, 0, 1, _alpha);
			}
			
			// Next, the player's power bomb ammunition reserves are drawn if they have access to them. The code for
			// doing so is identical to how the missile ammo info is drawn to the screen, but offset further along
			// to the right to compensate for that infomation.
			if (event_get_flag(FLAG_POWER_BOMBS) && maxPowerBombs > 0){
				var _textColor = c_white;
				var _iconColor = c_white;
				if (IN_MORPHBALL && IS_ALT_WEAPON_HELD){ // Highlight colors whenever power bombs are being utilized.
					_textColor = HEX_LIGHT_GREEN;
					_iconColor = HEX_LIGHT_GREEN;
				} else if (numPowerBombs == maxPowerBombs){	// Highlight when power bomb ammo is maximized.
					_textColor = HEX_LIGHT_YELLOW;
					// Icon color remains unchanged by this condition.
				}
				
				// Highlight when there are no power bombs remaining.
				if (numPowerBombs == 0){
					_textColor = HEX_DARK_RED;
					_iconColor = HEX_GRAY;
				}
				
				draw_sprite_ext(spr_power_bomb_icon, 0, _xOffset, _yOffset - 1, 1, 1, 0, _iconColor, _alpha);
				_xOffset += sprite_get_width(spr_power_bomb_icon);
				draw_number_as_sprite(_xOffset, _yOffset, numPowerBombs, spr_ammo_numbers, _textColor, 2, 0, 1, _alpha);
			}
			
			// Finally, the player's aeion gauge is drawn below the energy, missile, and power bomb information. It
			// is a one pixel tall and 50 pixel width rectangle that will be yellow to signify the remaining aeion
			// with a black backing that is the same dimensions as the gauge. A small yellow circle that glows is
			// drawn to the left of the bar; pulsing faster or slower depending on the amount of aeion left relative
			// to the guage's current maximum. When no aeion is left, the circle will be greyed out and static.
			if (maxAeion > 0){
				var _aeionRatio = (_pCurAeion / maxAeion);
				var _aeionGuageSize = _aeionRatio * AEION_GUAGE_WIDTH;
				draw_sprite_ext(spr_rectangle, 0, _xPos + 9, _yPos + 15, AEION_GUAGE_WIDTH,	2, 0, HEX_BLACK, _alpha);
				draw_sprite_general(spr_rectangle, 0, 1, 1, 1, 1, _xPos + 9, _yPos + 15, _aeionGuageSize, 2, 0, 
					HEX_DARK_YELLOW, HEX_LIGHT_YELLOW, HEX_LIGHT_YELLOW, HEX_DARK_YELLOW, _alpha);
				
				if (_pCurAeion == 0){
					draw_sprite_ext(spr_aeion_icon, 0, _xPos + 2, _yPos + 16, 1, 1, 0, HEX_DARK_GRAY, _alpha);
				} else{
					_glowStrength = value_set_linear(_glowStrength, _glowTarget, (_aeionRatio * 0.04) + 0.01);
					if (_glowStrength == _glowTarget) {_glowTarget = (_glowTarget == 1.0) ? 0.0 : 1.0;}
					
					if (aeionCooldownTimer > 0.0){ // Display Aeion Icon in red to signify the use of aeion abilities is on cooldown. 
						draw_sprite_ext(spr_aeion_icon, 0, _xPos + 2, _yPos + 16, 1, 1, 0, HEX_DARK_RED, _alpha);
					} else{ // When aeion is ready to use, the icon is shown normally alongside a pulsating glow surrounding it.
						draw_sprite_ext(spr_aeion_icon, 0, _xPos + 2, _yPos + 16, 1, 1, 0, c_white, _alpha);
						draw_sprite_ext(spr_aeion_icon_glow, 0, _xPos + 2, _yPos + 16, 1, 1, 0, c_white, _glowStrength * _alpha);
					}
				}
			}
			
			_curEnergy		= hitpoints;
			_curMissiles	= numMissiles;
			_curAeion		= curAeion;
		}
		glowStrength = _glowStrength;
		glowTarget = _glowTarget;
		
		if (GAME_CURRENT_STATE != GSTATE_NORMAL) {return;}
		
		// Increment and decrement that various numerical animation values towards whatever their actual values
		// within the player object's data. This method is inspired by how Mario 64's coin counter worked;
		// increases the value frame-by-frame until it matched what the actual value in the data was.
		pCurEnergy		= value_set_relative(pCurEnergy, _curEnergy, ENERGY_INCREMENT_SPEED);
		pCurMissiles	= value_set_relative(pCurMissiles, _curMissiles, MISSILE_INCREMENT_SPEED);
		pCurAeion		= value_set_relative(pCurAeion, _curAeion, AEION_GAUGE_FILL_SPEED);
	}
}

#endregion

#region Global functions related to obj_player_hud
#endregion