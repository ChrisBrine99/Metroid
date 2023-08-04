#region	Initializing any macros that are useful/related to obj_player_hud

// 
#macro	SHOW_MISSILES			0
#macro	SHOW_PBOMBS				1
#macro	SHOW_AEION_GAUGE		2

// 
#macro	USING_MISSILE			0
#macro	USING_POWER_BOMB		1
#macro	AEION_COOLDOWN			2

// 
#macro	CAN_SHOW_MISSILES		(stateFlags & (1 << SHOW_MISSILES))
#macro	CAN_SHOW_PBOMBS			(stateFlags & (1 << SHOW_PBOMBS))
#macro	CAN_SHOW_AEION_GAUGE	(stateFlags & (1 << SHOW_AEION_GAUGE))

// 
#macro	ENERGY_INCREMENT_SPEED	0.3
#macro	AEION_INCREMENT_SPEED	0.25
#macro	MISSILE_INCREMENT_SPEED 0.75
#macro	PBOMB_INCREMENT_SPEED	0.5

// 
#macro	LOW_ENERGY_THRESHOLD	30.0

// 
#macro	ENERGY_NUMBER_WIDTH		10
#macro	ETANK_ROW_LIMIT			6
#macro	ETANK_ICON_WIDTH		6
#macro	ETANK_ICON_HEIGHT		6
#macro	MISSILE_NUMBER_WIDTH	5

// 
#macro	MISSILE_ICON_WIDTH		12
#macro	POWER_BOMB_ICON_WIDTH	8

// 
#macro	AEION_GAUGE_XOFFSET		9
#macro	AEION_GAUGE_YOFFSET		17
#macro	AEION_GUAGE_WIDTH		47
#macro	AEION_GAUGE_HEIGHT		2

#endregion

#region Initializing enumerators that are useful/related to obj_player_hud
#endregion

#region Initializing any globals that are useful/related to obj_player_hud
#endregion

#region The main object code for obj_player_hud

/// @param {Real} index		Unique value generated by GML during compilation that represents this struct asset.
function obj_game_hud(_index) : base_struct(_index) constructor{
	// Stores a set of 32 bits that can determine visibility of certain elements on the player's HUD; where
	// the value 1 says it can be shown and 0 says it should be skipped and thus not drawn.
	stateFlags = 0;
	
	// Controls the opacity level for the ENTIRE in-game HUD, and it can be dynamically changed by setting
	// the "alphaTarget" variables to different values between 0.0 and 1.0.
	alpha			= 1.0;
	alphaTarget		= 1.0;
	
	// Stores the values for the aeion gauge's glowing animation, which is processed inside the player object
	// using local variables. Without these, the local values would be lost and endless reset to their initial
	// values instead of actually performing the glowing pulse animation.
	glowStrength	= 0.0;
	glowTarget		= 1.0;
	
	// 
	pCurEnergy		= 0.0;
	pCurAeion		= 0.0;
	pCurMissiles	= 0.0;
	pCurPowerBombs	= 0.0;
	
	// 
	pMaxEnergyTanks = 0;
	pMaxAeion		= 0;
	pMaxMissiles	= 0;
	pMaxPowerBombs	= 0;
	
	/// @description Functions identically to how the "Draw GUI" event works within a GML object, so it should
	/// be called in such event of the object that manages the game hud insteance. In short, it calls functions 
	/// that will draw each part of the HUD; the player information, equipped and available beam information, 
	/// minimap, and so on.
	draw_gui = function(){
		alpha = value_set_linear(alpha, alphaTarget, 0.1);
		if (alpha == 0.0) {return;} // Ignore processing any HUD element if it's completely invisible.
		
		draw_player_info_background(0, 0, alpha);
		draw_player_info(2, 2, alpha);
	}
	
	/// @description 
	/// @param {Real}	x		Starting x offset for the player info background elements on the screen.
	/// @param {Real}	y		Starting y offset for the player info background elements on the screen.
	/// @param {Real}	alpha	The overall visibility of the background displayed on the HUD.
	draw_player_info_background = function(_x, _y, _alpha){
		/*var _xx				= _x + 1;
		var _mainBgWidth	= 24;  // Start at 24 since current energy value is 20 pixels wide; plus 2 pixel spacing on each side.
		
		var _maxEnergyTanks = floor(PLAYER.maxHitpoints * 0.01);
		if (_maxEnergyTanks > 0){
			var _energyBgWidth = _maxEnergyTanks <= 6 ? 22 + (6 * _maxEnergyTanks) + 1 : 22 + 37; // Tank sprite: 6x6; plus one pixel for spacing.
			draw_sprite_ext(spr_rectangle, 0, _xx, _y + 1, _energyBgWidth, 14, 0, HEX_BLACK, _alpha * 0.25);
			_mainBgWidth += _energyBgWidth - 22; // Ignore 22 pixels since mainBgWidth already includes it.
			_xx			 += _energyBgWidth + 1;
		} else{
			draw_sprite_ext(spr_rectangle, 0, _xx, _y + 1, 22, 14, 0, HEX_BLACK, _alpha * 0.25);
			_xx += _x + _mainBgWidth - 1;
		}
		
		if (stateFlags & (1 << SHOW_MISSILES)){
			draw_sprite_ext(spr_rectangle, 0, _xx, _y + 1, 28, 11, 0, HEX_BLACK, _alpha * 0.25);
			_mainBgWidth += 29; // Add 1 pixel for missile background spacing.
			_xx			 += 29;
		}
		
		if (stateFlags & (1 << SHOW_PBOMBS)){
			draw_sprite_ext(spr_rectangle, 0, _xx, _y + 1, 20, 11, 0, HEX_BLACK, _alpha* 0.25);
			_mainBgWidth += 21; // Add 1 pixel for power bomb background spacing.
			_xx			 += 21;
		}
		
		draw_sprite_ext(spr_rectangle, 0, _x, _y, _mainBgWidth, 16, 0, HEX_BLACK, _alpha * 0.5);*/
	}
	
	/// @description Displays the player's current energy along with their current energy tank sum--whether
	/// they are currently filled or empty. Also, the ammunition reserve for Samus's missiles and power bombs
	/// are also dispayed using this function. Her aeion gauge is also shown if she has access to it.
	/// @param {Real}	x		Starting x offset that all player info is displayed with regards to.
	/// @param {Real}	y		Starting y offset that all player info is displayed with regard to.
	/// @param {Real}	alpha	The overall visibility of player information displayed on the HUD.
	draw_player_info = function(_x, _y, _alpha){
		// First, create some local variables that will be manipulated and altered throughout the function.
		// The first four values are passed into the Player object's scope to update their stored numbers
		// relative to its internal values, and the last variable stores "substate" flags that change how
		// the certain aspects of the HUD are drawn.
		var _pCurEnergy		= pCurEnergy;
		var _pCurAeion		= pCurAeion;
		var _pCurMissiles	= pCurMissiles;
		var _pCurPowerBombs	= pCurPowerBombs;
		var _pSubStates		= 0;
		with(PLAYER){
			// Update values relative to the values within the player object that they represent when drawn.
			// The ammunition values will be incremented/decremented at a regular interval, and the aeion/
			// energy values have a "relative" method which slows the interval as the value nears its target.
			_pCurEnergy		= value_set_relative(_pCurEnergy,	hitpoints,		ENERGY_INCREMENT_SPEED);
			_pCurAeion		= value_set_relative(_pCurAeion,	curAeion,		AEION_INCREMENT_SPEED);
			_pCurMissiles	= value_set_linear(_pCurMissiles,	numMissiles,	MISSILE_INCREMENT_SPEED);
			_pCurPowerBombs	= value_set_linear(_pCurPowerBombs,	numPowerBombs,	PBOMB_INCREMENT_SPEED);
			
			// Check some conditions that will be stored in the local "_pSubStates" variable, which will change
			// how certain aspects of the HUD are shown to the player: highlighting ammo information for an 
			// in-use weapon, to a temporary cooldown on an ability, and so on.
			if (curWeapon == curMissile)			{_pSubStates |= (1 << USING_MISSILE);}
			if (IN_MORPHBALL && IS_ALT_WEAPON_HELD)	{_pSubStates |= (1 << USING_POWER_BOMB);}
			if (aeionCooldownTimer > 0.0)			{_pSubStates |= (1 << AEION_COOLDOWN);}
		}
		
		// Copy the updated floating point values into the HUD's variables for each piece of information that
		// is then rendered onto the screen using this information. However, the local values are utilized in
		// the rendering process since local values are much faster than object variables.
		pCurEnergy		= _pCurEnergy;
		pCurAeion		= _pCurAeion;
		pCurMissiles	= _pCurMissiles;
		pCurPowerBombs	= _pCurPowerBombs;
		
		// Draw the aeion gauge below Samus's energy value and energy tank information if the HUD is allowed
		// to render said information. If not, the HUD will skip over any rendering related to the gauge.
		if (CAN_SHOW_AEION_GAUGE){
			// The edges of the aeion gauge, which is represented by two white rectangles that are shaped like
			// square brackets [] after the gauge is drawn on the left and right side of it, respectively.
			draw_sprite_ext(
				spr_rectangle, 0,					// <-- These can be ignored
					_x + AEION_GAUGE_XOFFSET - 1,	// X and Y position relative to top-left of screen.
					_y + AEION_GAUGE_YOFFSET - 1,	
					2, AEION_GAUGE_HEIGHT + 2,		// Width and height of the left edge.
				0, c_white, _alpha					// Angle, color, and opacity.
			);
			draw_sprite_ext(
				spr_rectangle, 0,					// See comments above for what these arguments represent.
					_x + AEION_GAUGE_XOFFSET + AEION_GUAGE_WIDTH - 1,
					_y + AEION_GAUGE_YOFFSET - 1,
					2, AEION_GAUGE_HEIGHT + 2,
				0, c_white, _alpha
			);
			
			// Drawing the gauge itself, which has a black background that is the size the gauge should be
			// when it is completely full, as well as a yellow bar that has a horizontal gradient between a
			// darker yellow and bright yellow that represents the remaining aeion relative to the gauge size.
			// Rendering the gauge's background is skipped if the aeion gauge is full.
			var _aeionRatio		= (_pCurAeion / pMaxAeion);
			var _aeionGuageSize = _aeionRatio * AEION_GUAGE_WIDTH;
			if (_aeionRatio < 1.0){
				draw_sprite_ext(
					spr_rectangle, 0,				// <-- These can be ignored.
						_x + AEION_GAUGE_XOFFSET, 	// X and Y position relative to top-left of screen.
						_y + AEION_GAUGE_YOFFSET, 
						AEION_GUAGE_WIDTH,			// Width and height of the gauge's background.
						AEION_GAUGE_HEIGHT,			
					0, HEX_BLACK, _alpha			// Angle, color, and opacity.
				);
			}
			draw_sprite_general(
				spr_rectangle, 0, 1, 1, 1, 1,		// <-- These can all be ignored.
					_x + AEION_GAUGE_XOFFSET,		// X and Y position relative to top-left of screen.
					_y + AEION_GAUGE_YOFFSET, 
					_aeionGuageSize,				// Width and height of the gauge's background.
					AEION_GAUGE_HEIGHT,	
				0,		// This (Angle) can be ignored as well.
				HEX_DARK_YELLOW, HEX_LIGHT_YELLOW,	// Top-left and top-right color for the rectangle.
				HEX_LIGHT_YELLOW, HEX_DARK_YELLOW,	// Bottom-right and bottom-left colors.
				_alpha	// Opacity of the gauge.
			);
			
			// Display the aeion gauge's icon to the left of the gauge itself. If Samus has no aeion remaining,
			// the icon is drawn with a dark gray hue. Otherwise, it is drawn with a pulsating glow or with a
			// dark red hue and no glow depending on what is required.
			_pCurAeion = floor(_pCurAeion); // Discard any decimal value from this point onward.
			if (_pCurAeion == 0){
				draw_sprite_ext(spr_aeion_icon, 0, _x, _y + 18, 1, 1, 0, HEX_DARK_GRAY, _alpha);
			} else{
				// Increment and decrement the "glowStrength" variable within the range of 0.0 and 1.0; the
				// speed of that value's change increasing/decreasing relative to how full the gauge is.
				glowStrength = value_set_linear(glowStrength, glowTarget, (_aeionRatio * 0.04) + 0.01);
				if (glowStrength == glowTarget) {glowTarget = (glowTarget == 1.0) ? 0.0 : 1.0;}
				
				// Determine how to draw the aeion gauge's icon based on what is currently happening with
				// Samus's aeion abilities. If said abilities are on cooldown, the icon doesn't glow and is
				// tinted a dark red. Otherwise, it is drawn normally and the icon's glow is visible.
				if (_pSubStates & (1 << AEION_COOLDOWN)){
					draw_sprite_ext(spr_aeion_icon, 0, _x, _y + 18, 1, 1, 0, HEX_DARK_RED, _alpha);
				} else{
					draw_sprite_ext(spr_aeion_icon, 0, _x, _y + 18, 1, 1, 0, c_white, _alpha);
					draw_sprite_ext(spr_aeion_icon_glow, 0, _x, _y + 18, 1, 1, 0, c_white, glowStrength * _alpha);
				}
			}
		}
		
		// Display Samus's "energy value", which is the remaining value between 1 and 99 that exists within
		// her hitpoint value within the game's data. The remaining amount is drawn as an energy tank icon 
		// below for every 100 units available in the hitpoint value.
		var _numColor	= c_white;
		if (_pCurEnergy <= LOW_ENERGY_THRESHOLD) // Tint the energy number dark red when Samus has less than 30 energy.
			_numColor	= HEX_DARK_RED;
		draw_number_as_sprite(_x, _y, floor(_pCurEnergy) % 100, spr_energy_numbers, _numColor, 2, 0, 1, _alpha);
		
		// The player's current hitpoint value is no longer required, so it will be reduced by a 100th and then
		// floored to get the current number of energy tanks that are full. This is then used in the loop below
		// to drawn full energy tanks versus empty energy tanks.
		_pCurEnergy = floor(_pCurEnergy * 0.01);
		
		// Display all the player's currently available energy tanks onto the screen; with no spacing between
		// each of the icons along both axes, but one pixel of padding between the energy number and this info.
		var _xx	= _x + (ENERGY_NUMBER_WIDTH << 1) + 1;
		var _yy	= (pMaxEnergyTanks <= ETANK_ROW_LIMIT) ? _y + (ETANK_ICON_HEIGHT >> 1) : _y;
		var _ammoOffset = _xx + 1;
		for (var i = 0; i < pMaxEnergyTanks; i++){
			if (i == ETANK_ROW_LIMIT){ // Reset x offset and shift y offset down for a new row.
				_xx	= _x + (ENERGY_NUMBER_WIDTH << 1) + 1;
				_yy	= _y + ETANK_ICON_HEIGHT;
			}
			
			// Draws an Energy Icon for each energy tank Samus current has available to her. Filled tanks are
			// drawn using the first image in the sprite, and the second image is used for empty tanks.
			draw_sprite_ext(spr_energy_tank_icon, (i < _pCurEnergy), _xx, _yy, 1, 1, 0, c_white, _alpha);
			_xx += ETANK_ICON_WIDTH; // Shift right for next icon.
		}
		
		// Determine the starting offset for the missile/power bomb information relative to the current number
		// of Energy Tanks the player has available to them. If the value is less than 6 (But higher than 0),
		// the offset is relative to the current number of energy tanks. This offset maxes out at 6, so the
		// amount of energy tanks after that becomes irrelevant and a constant offset of six icons is used.
		if (pMaxEnergyTanks > ETANK_ROW_LIMIT)	{_ammoOffset += 1 + (ETANK_ICON_WIDTH * ETANK_ROW_LIMIT);}
		else if (pMaxEnergyTanks != 0)			{_ammoOffset += 1 + (ETANK_ICON_WIDTH * pMaxEnergyTanks);}
		
		// Render the player's current missile ammunition to the screen if the HUD is allowed to show that
		// information. Otherwise, the data will remain invisible to the player.
		if (CAN_SHOW_MISSILES){
			_pCurMissiles	= floor(_pCurMissiles); // Discard any decimal value.
			_ammoOffset	   += draw_ammunition_info(_ammoOffset, _y, _pCurMissiles, pMaxMissiles, 3, 
								  spr_missile_icon, _pSubStates & (1 << USING_MISSILE), _alpha) + 2;
		}
		
		// Render the player's current power bomb supply to the screen if the HUD is allowed to show that
		// information. Otherwise, the data will remain invisible to the player.
		if (CAN_SHOW_PBOMBS){
			_pCurPowerBombs = floor(_pCurPowerBombs); // Discard any decimal value.
			draw_ammunition_info(_ammoOffset, _y, _pCurPowerBombs, pMaxPowerBombs, 2, 
				spr_power_bomb_icon, _pSubStates & (1 << USING_POWER_BOMB), _alpha);
		}
	}
	
	/// @description A default method of rendering ammunition information to the game's HUD. It renders an
	/// image followed by a numerical value to represent that ammunition on screen. The wiudth of this info
	/// in pixels is returned so other HUD elements can be lined up relative to whatever is drawn here if
	/// needed.
	/// @param {Real}	x				Position along the x-axis to display the ammo info at on the screen.
	/// @param {Real}	y				Position along the y-axis to display the ammo info at on the screen.
	/// @param {Real}	curAmmo			Value to use as the representation for the currently available ammo.
	/// @param {Real}	maxAmmo			Value to use as the maximum possible amount of ammo to have at once.
	/// @param {Real}	totalPVs		Total number of place values to render (Unused place values are shown as 0).
	/// @param {Real}	ammoIcon		Sprite that represents the ammunition; drawn to the left of the amount.
	/// @param {Bool}	weaponInUse		Highlights the ammo info with a light green hue if true.
	/// @param {Real}	alpha			The overall visibility of the elements on the screen (From 0.0 - 1.0).
	draw_ammunition_info = function(_x, _y, _curAmmo, _maxAmmo, _totalPVs, _ammoIcon, _weaponInUse, _alpha){
		var _ammoColor = c_white;
		var _iconColor = c_white;
		if (_curAmmo == 0){
			_ammoColor = HEX_DARK_RED;
			_iconColor = HEX_GRAY;
		} else if (_weaponInUse){
			_ammoColor = HEX_LIGHT_GREEN;
			_iconColor = HEX_LIGHT_GREEN;
		} else if (_curAmmo == _maxAmmo){
			_ammoColor = HEX_LIGHT_YELLOW;
			// Icon color isn't altered by a given ammunition amount being maxed out.
		}
		
		// Render the ammunition's icon; followed by the ammunition amount to the right of that; returning the
		// final width of the drawn information in pixels after drawing the ammo count.
		draw_sprite_ext(_ammoIcon, 0, _x, _y, 1, 1, 0, _iconColor, _alpha);
		var _xOffset = sprite_get_width(_ammoIcon);
		return _xOffset + draw_number_as_sprite(_x + _xOffset, _y + 1, _curAmmo, spr_ammo_numbers, _ammoColor, _totalPVs, 0, 1, _alpha);
	}
}

#endregion

#region Global functions related to obj_player_hud
#endregion