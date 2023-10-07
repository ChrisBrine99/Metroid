// If the enemy was spawned from a spawner object, decrement the current number of instances that currently
// exist due to said spawner, and then spawn an item if the enemy is able to actually drop an item.
with(linkedSpawnerID) {curInstances--;}
if (!ENMY_CAN_DROP_ITEM) 
	return;

// Calculate a random integer between 1 and 100. Then, loop through the array of item drops; skipping over any
// values that are set to 0. If no item can be dropped, nothing will occur. Otherwise, the designated drop will
// be created at the position where the enemy died.
var _dropChance = irandom_range(1, 100);
var _baseChance = 0;
for (var i = 0; i < ENMY_TOTAL_DROPS; i++){
	if (dropChances[i] == 0) {continue;}
	
	// Increase the "_baseChance" value by whatever the drop chance for the next drop to check against and then
	// use that calculated sum to see if the item should be dropped by the enemy. If not, the loop moves onto 
	// the next item's drop chance in the array.
	_baseChance += dropChances[i];
	if (_dropChance <= _baseChance){
		spawn_item_drop(i);
		break;
	}
}