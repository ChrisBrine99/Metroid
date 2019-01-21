/// @description Insert description here
// You can write your code in this editor

if (global.event[index] == true)
	return;

if (!beenTriggered){
	if (instance_exists(obj_beam)){
		var beam = instance_nearest(x, y, obj_beam);
		if (place_meeting(x, y, beam))
			beenTriggered = true;
	}
}
else{
	if (spawnTimer >= maxTimer && numSpawned < numToSpawn) 
		instance_create_depth(startPosX, startPosY, 300, obj_dblock_regen);
	spawnTimer--;
	if (spawnTimer < 0){
		if (numSpawned < numToSpawn){
			instance_create_depth(startPosX, startPosY, 300, obj_event_block);
			startPosX += 16 + blockGap;
			numSpawned++;
			spawnTimer = maxTimer;
		}
		else{
			global.event[index] = true;
		}
	}
}