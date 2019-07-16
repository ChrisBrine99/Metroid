/// @description Removing the ambient light source
// You can write your code in this editor

if (ambLight != noone){
	instance_destroy(ambLight);
	ambLight = noone;
}