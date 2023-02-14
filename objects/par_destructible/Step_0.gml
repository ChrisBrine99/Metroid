// When destroyed, the block will have its respawn timer counted up until it reaches a desired value. After that,
// the block will play a regeneration animation and it will be reset to how it was before it was destroyed.
if (IS_DESTROYED && GAME_CURRENT_STATE == GSTATE_NORMAL){
	respawnTimer += DELTA_TIME;
	if (respawnTimer >= timeToRespawn && timeToRespawn != RESPAWN_TIMER_INFINITE && effectID == noone){
		if (CAN_USE_EFFECTS){
			var _x = x;
			var _y = y;
			var _id = id;
			var _imageIndex = sprite_get_number(spr_destructible_effect) - 1;
			effectID = instance_create_struct(obj_destructible_effect);
			with(effectID){
				x =				_x;
				y =				_y;
				parentID =		_id;
				imageIndex =	_imageIndex;
				animSpeed =		-1;
			}
		}
		stateFlags &= ~(1 << DESTROYED);
		respawnTimer = 0;
	}
}