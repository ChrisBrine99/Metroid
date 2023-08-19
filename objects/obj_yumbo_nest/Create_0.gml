#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();
// All nests and "spawner" type objects will have inherent immunities to all status ailments that can be applied
// by Samus's arsenal. On top of that, her Screw Attack is ineffective against spawners.
stateFlags |= (1 << STUN_IMMUNITY) | (1 << SHOCK_IMMUNITY)
		| (1 << FREEZE_IMMUNITY) | (1 << SCREW_ATTACK_IMMUNITY);

// Maximum HP of the Yumbo Nest is set to one to ensure the weaponry that it's weak to (Missiles, Power Bombs,
// etc.) will destroy it upon collision.
maxHitpoints	= 1;
hitpoints		= maxHitpoints;

#endregion

#region Unique variable initialization

// These variables determine what Enemy object is spawned, as well as the positional offset relative to the
// position of the spawner itself that these Enemies are created at.
objToSpawn		= noone;
spawnOffsetX	= 0;
spawnOffsetY	= 0;

// Keeps track of the current amount of instances that have been spawned by a given spawner and the maximum
// possible number of instances existing at one time the spawn can have, respectively.
curInstances	= 0;
maxInstances	= 0;

// Stores how much time in "units" (60 units = 1 second) that a spawner must wait before it can create its
// chosen Enemy object and the current time the spawner has been waiting for before it is able to spawn said 
// object, respectively.
timeToSpawn		= 0.0;
spawnTimer		= 0.0;

#endregion

#region Initialize function override

/// Store the pointer for the parent's initialize function into a local variable for the Yodare, which is then
/// called inside its own initialization function so the original functionality isn't ignored.
__initialize = initialize;
/// @description Initialization function for the Yumbo Nest (Note that this function isn't called by any of its
/// children since they'll utilize the initialize function stored in "__initialize" instead). It sets what Enemy
/// to spawn in (The "Yumbo"), as well as the timer to spawn them in and the maximum number of instances (2) this
/// spawner can have alive at any given time. On top of that, its sprite and weakness to missiles are set here.
/// @param {Function} state		The function to use for this entity's initial state.
initialize = function(_state){
	__initialize(_state);
	entity_set_sprite(spr_yumbo_nest, -1);
	create_general_collider();
	initialize_weak_to_missiles();
	objToSpawn		= obj_yumbo;
	maxInstances	= 2;
	timeToSpawn		= 120.0;
	spawnTimer		= timeToSpawn * 0.75;	// First instance spawn only requires 25% of the normal time.
}

#endregion

#region State function initialization

/// @description The default state for the Yumbo Nest as well as other general Enemy spawners if they don't
/// require any additional functionality on top of the Enemy object spawning. All it does it increment the
/// "spawnTimer" variable until it surpasses the value found in "timeToSpawn", which will then cause a creation
/// of a Yumbo instance before the timer resets to create another.
state_default = function(){
	// Prevent the spawner from incrementing its spawn timer if it is currently off-screen, deactivated, has
	// the maximum amount of instances it can create alive in the world OR it doesn't have a object to spawn.
	if (!IS_ON_SCREEN || !IS_ACTIVE || curInstances == maxInstances || objToSpawn == noone) {return;}
	
	spawnTimer += DELTA_TIME;
	if (spawnTimer > timeToSpawn){ // Spawn Enemy object and link it to the spawner that created it.
		var _instance = instance_create_object(x + spawnOffsetX, y + spawnOffsetY, objToSpawn);
		_instance.linkedSpawnerID = id;
		spawnTimer = 0.0;
		curInstances++;
	}
}

#endregion

// Only call the current initialization function if the index in question IS the Yumbo Nest itself. Otherwise,
// it should be skipped for the child spawner's own initialization function.
if (object_index == obj_yumbo_nest) {initialize(state_default);}