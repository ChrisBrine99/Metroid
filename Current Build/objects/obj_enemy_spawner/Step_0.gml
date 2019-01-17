/// @description Spawning the enemy in
// You can write your code in this editor

// Check if the pause menu has been opened
if (instance_exists(obj_pause_menu) || global.itemCollected || x <= global.camX - 32 || x >= global.camX + global.camWidth + 32 || y <= global.camY - 32 || y >= global.camY + global.camHeight + 32){
	exit;
}

if (!hasSpawned){
	spawnTimer--;
	if (spawnTimer <= 0){
		spawnTimer = 15 + round(random(45));
		if (!place_meeting(x, y - 16, obj_samus) && !place_meeting(x, y + 16, obj_samus)){
			hasSpawned = true;
			var obj = instance_create_depth(x, y, depth, objToSpawn);
			obj.type = typeToSpawn;
			obj.spawner = instance_nearest(x, y, obj_enemy_spawner);
		}
	}
}