#region Macro initializations

// ------------------------------------------------------------------------------------------------------- //
//	
// ------------------------------------------------------------------------------------------------------- //

#macro	MCOL_MOVE_NONE			0
#macro	MCOL_MOVE_VERTICAL		1
#macro	MCOL_MOVE_HORIZONTAL	2
#macro	MCOL_MOVE_RADIAL		3

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
curSpeedFraction = 0.0;

// 
moveDirection	= MCOL_DIR_POSITIVE;
moveStyle		= MCOL_MOVE_NONE;
moveParams		= noone;

// 
waitTimer		= 0.0;

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

/// @description 
/// @param {Real}	curValue		
/// @param {Real}	minValue		
/// @param {Real}	maxValue		
move_along_axis = function(_curValue, _minValue, _maxValue){
	if (_curValue < _minValue || _curValue > _maxValue){
		waitTimer		= moveParams.waitInterval;
		curSpeed		= 0.0;
		moveDirection  *= -1;
		
		return clamp(_curValue, _minValue, _maxValue);
	}
	
	return _curValue;
}

#endregion