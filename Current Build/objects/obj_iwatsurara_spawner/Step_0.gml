/// @description Spawning the enemy in
// You can write your code in this editor

if (!hasSpawned){
	spawnTimer--;
	if (spawnTimer <= 0){
		spawnTimer = 30;
		instance_create_depth(x, y, depth, obj_iwatsurara);
		hasSpawned = true;
	}
}