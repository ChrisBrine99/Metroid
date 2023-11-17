// 
if (moveStyle == MCOL_MOVE_NONE || GAME_CURRENT_STATE == GSTATE_PAUSED)
	return;
var _deltaTime = DELTA_TIME;

// 
if (waitTimer > 0.0){
	waitTimer -= _deltaTime;
	if (waitTimer <= 0.0)
		waitTimer = 0.0;
	return;
}


//
curSpeed += _deltaTime * accel * moveDirection;
if (curSpeed > maxSpeed || curSpeed < -maxSpeed)
	curSpeed = maxSpeed * moveDirection;

// 
var _deltaSpeed		= curSpeed * _deltaTime;
_deltaSpeed		   += curSpeedFraction;
curSpeedFraction	= _deltaSpeed - (floor(abs(_deltaSpeed)) * sign(_deltaSpeed));
_deltaSpeed		   -= curSpeedFraction;

// 
switch(moveStyle){
	case MCOL_MOVE_HORIZONTAL:
		x = move_along_axis(x + _deltaSpeed, moveParams.x1, moveParams.x2);
		break;
	case MCOL_MOVE_VERTICAL:
		y = move_along_axis(y + _deltaSpeed, moveParams.y1, moveParams.y2);
		break;
}