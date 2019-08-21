/// @description Updating Debug Menu information
// You can write your code in this editor

numInstances = string(instance_number(all));

// Adding up all the current active objects that are in the room
numActiveObjects = string(instance_number(obj_culled_object) + 
						  instance_number(obj_entity_controller) + 
						  instance_number(par_interactable_block) +
						  instance_number(par_player_effect) +
						  instance_number(obj_hud) +
						  instance_number(obj_camera) +
						  instance_number(obj_controller) +
						  instance_number(obj_debug_controller));

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