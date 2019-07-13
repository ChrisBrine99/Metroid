/// @description Restart And/Or End the Animation
// You can write your code in this editor

if (!canRepeat){
	instance_destroy(self);
} else{
	curRepeat++;
	if (curRepeat > numRepeats){
		instance_destroy(self);	
	}
}