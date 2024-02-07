// 
if (GAME_CURRENT_STATE != GSTATE_NORMAL)
	return;
	
// 
var _deltaTime = DELTA_TIME;

// 
if (hspd != 0.0){
	deltaHspd		= (hspd * _deltaTime) + hspdFraction;
	hspdFraction	= deltaHspd - (floor(abs(deltaHspd)) * sign(deltaHspd));
	deltaHspd	   -= hspdFraction;
	x			   += deltaHspd;
}

// 
if (vspd != 0.0){
	deltaVspd		= (vspd * _deltaTime) + vspdFraction;
	vspdFraction	= deltaVspd - (floor(abs(deltaVspd)) * sign(deltaVspd));
	deltaVspd	   -= vspdFraction;
	y			   += deltaVspd;
}