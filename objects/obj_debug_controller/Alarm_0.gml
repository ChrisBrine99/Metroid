/// @description Updating Debug Menu information
// You can write your code in this editor

numInstances = string(instance_number(all));

// Adding up all the current active objects that are in the room
numActiveObjects = string(numInstances - instance_number(par_block));

// Adding up all the current active entities (Player Objects, Enemies, Projectiles, etc) in the current room
numEntities = string(ds_list_size(global.entities));
var total = 0;
for (var i = 0; i < numEntities; i++){
	var curInstance = ds_list_find_value(global.entities, i);
	with(curInstance){
		if (canMove) {total++;}
	}
}
numActiveEntities = string(total);
numDrawnEntities = string(global.numDrawn);

numLightSources = string(ds_list_size(global.lightSources));
numDrawnLights = string(obj_lighting.numDrawn);

// Restart the timer
alarm[0] = 5;