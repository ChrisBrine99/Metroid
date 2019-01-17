/// @description Lets the enemy face a random direction. (50% Right, 50% Left)

// This makes sure it's actually randomized
randomize();

// Setting the direction
var rand = random(100);
if (rand < 50) right = true;
else left = true;