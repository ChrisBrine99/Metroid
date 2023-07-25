if (IS_DESTROYED || !IS_ACTIVE || GAME_CURRENT_STATE != GSTATE_NORMAL) {return;}
event_inherited();

if (curAilment != AIL_NONE){
	ailmentTimer -= DELTA_TIME;
	if (ailmentTimer <= 0.0) {remove_active_ailment();}
}