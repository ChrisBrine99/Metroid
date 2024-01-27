// 
with(linkedSpawnerID) 
	curInstances--;
linkedSpawnerID = noone;

// 
stateFlags |= ENTT_DESTROYED;
visible		= false;