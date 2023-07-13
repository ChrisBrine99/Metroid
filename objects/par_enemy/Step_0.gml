event_inherited();

if (IS_DESTROYED || GAME_CURRENT_STATE != GSTATE_NORMAL) {return;}

if (curAilment != AIL_NONE){
	ailmentTimer -= DELTA_TIME;
	if (ailmentTimer <= 0.0) {remove_active_ailment();}
}