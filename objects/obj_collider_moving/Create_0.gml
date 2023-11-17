#region Macro initializations

// ------------------------------------------------------------------------------------------------------- //
//	
// ------------------------------------------------------------------------------------------------------- //

#macro	MCOL_MOVE_NONE			0
#macro	MCOL_MOVE_VERTICAL		1
#macro	MCOL_MOVE_HORIZONTAL	2
#macro	MCOL_MOVE_ON_COLLIDE	3
#macro	MCOL_MOVE_RADIAL		4

// ------------------------------------------------------------------------------------------------------- //
//	
// ------------------------------------------------------------------------------------------------------- //

#macro	MCOL_DIR_POSITIVE		1
#macro	MCOL_DIR_NEGATIVE	   -1

#endregion

#region Unique variable initialization

// 
curSpeed	= 0.0;
maxSpeed	= 0.0;
accel		= 0.0;

// 
moveDirection	= MCOL_DIR_POSITIVE;
moveStyle		= MCOL_MOVE_NONE;
moveParams		= noone;

#endregion

#region Function initializations

/// @description 
/// @param {Real}	direction		
/// @param {Real}	accel			
/// @param {Real}	maxSpeed		
/// @param {Real}	moveStyle		
/// @param {Struct}	moveParams		
initialize = function(_direction, _accel, _maxSpeed, _moveStyle, _moveParams = noone){
	moveDirection	= _direction;
	accel			= _accel;
	maxSpeed		= _maxSpeed;
	moveStyle		= _moveStyle;
	moveParams		= _moveParams;
}

#endregion