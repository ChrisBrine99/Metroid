/// @description Insert description here
// You can write your code in this editor

// Call the parent's create event
event_inherited();

// Create and alter the ambient light source
ambLight = instance_create_depth(x, y, 15, obj_light_emitter);
ambLight.xRad = 12;
ambLight.yRad = 12;
ambLight.lightCol = c_orange;