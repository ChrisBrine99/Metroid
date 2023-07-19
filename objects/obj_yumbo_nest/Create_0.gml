#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();
// Set the proper sprite, The Yumbo Nest will only take damage from missiles (Plus the Power Bomb, but not the
// Screw Attack), and it will be immune to all types of status ailments.
entity_set_sprite(spr_yumbo_nest, -1);
initialize_weak_to_missiles();
stateFlags |= (1 << STUN_IMMUNITY) | (1 << SHOCK_IMMUNITY) 
	| (1 << FREEZE_IMMUNITY) | (1 << SCREW_ATTACK_IMMUNITY);

// Maximum HP of the Yumbo Nest is set to one to ensure the weaponry that it's weak to (Missiles, Power Bombs,
// etc.) will destroy it upon collision.
maxHitpoints = 1;
hitpoints = maxHitpoints;

#endregion

#region Unique variable initialization

objToSpawn		= obj_yumbo;
timeToSpawn		= 0.0;
spawnTimer		= 0.0;
maxInstances	= 1;

#endregion

#region State function initialization

/// @description 
state_default = function(){
	
}

// Set the Enemy Spawner to its default state upon creation.
object_set_next_state(state_default);

#endregion