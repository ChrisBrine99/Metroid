/// @description Removing the ambient light source
// You can write your code in this editor

if (ambLight != noone){
	instance_destroy(ambLight);
	ambLight = noone;
}

// Remove the entity from the ds_list of entity IDs
scr_remove_from_list(global.entities);