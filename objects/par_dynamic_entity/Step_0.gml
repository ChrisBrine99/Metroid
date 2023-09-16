// Prevent the object from processing anything if it has been destroyed OR it is currently inactive.
if (ENTT_IS_DESTROYED || !ENTT_IS_ACTIVE)
	return;

// Execute the entity's current state if there is a valid function index within the variable.
if (curState != NO_STATE) {curState();}

// Don't bother manipulating any hitstun/recovery timers if the entity isn't hitstunned OR the game's state isn't
// set to the normal state.
if (!ENTT_IS_HIT_STUNNED || GAME_CURRENT_STATE != GSTATE_NORMAL) 
	return;

// Once the initial hitstun timer has reached its required value, it will be set to -1.0. After that, the "recovery"
// phase of the hit is triggered to give the entity some time to recovery and move without worry of being hit again.
// The recovery timer hitting its required value will clear the "hitstun" flag and all the entity to be hit again.
if (hitstunTimer == -1.0){
	recoveryTimer += DELTA_TIME;
	if (recoveryTimer >= recoveryLength){
		stateFlags	   &= ~ENTT_HIT_STUNNED;
		recoveryTimer	= -1.0;
	}
	return; // The hitstun timer no longer needs to be incremented.
}

// Increment the hitstun timer until it hits or surpasses the length required by the attack sustained by the entity.
// After that, the state for the entity is reset to its previous one if they were set to NO_STATE during the stun.
hitstunTimer += DELTA_TIME;
if (hitstunTimer >= hitstunLength){
	if (curState == NO_STATE) {object_set_next_state(lastState);}
	hitstunTimer	= -1.0;
}