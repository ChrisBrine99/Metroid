/// @description Spawns 30 item pickups randomly around a set radius. Can be health pickups, missile pickups,
/// super missile pickups,  power bomb pickups or a combination of the four.
/// @param item1
/// @param item2
/// @param item3
/// @param item4
/// @param posX
/// @param posY
/// @param radius

var item1, item2, item3, item4, posX, posY, radius, chance, tempPosX, tempPosY;
item1 = argument0;
item2 = argument1;
item3 = argument2;
item4 = argument3;
posX = argument4;
posY = argument5;
radius = argument6;

for (var i = 0; i < 30; i++){
	// Set a random chance and random position for every enemy
	randomize();
	chance = floor(random(99)) + 1;
	tempPosX = posX + floor(random(choose(radius, -radius)));
	tempPosY = posY + floor(random(choose(radius, -radius)));
	// Stops health pickups from spawning inside of objects
	if (!place_free(tempPosX, tempPosY))
		continue;
	// There will be a 25% chance of spawning each item
	if (chance > 0 && chance <= 25)
		instance_create_depth(tempPosX, tempPosY, depth, item1);
	else if (chance > 25 && chance <= 50)
		instance_create_depth(tempPosX, tempPosY, depth, item2);
	else if (chance > 50 && chance <= 75)
		instance_create_depth(tempPosX, tempPosY, depth, item3);
	else if (chance >= 75)
		instance_create_depth(tempPosX, tempPosY, depth, item4);
}