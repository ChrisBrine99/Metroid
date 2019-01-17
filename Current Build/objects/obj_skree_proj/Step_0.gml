/// @description Count down until the projectile disappears
// You can write your code in this editor

// Update position
x += hspd;
y += vspd;

// Destroy when the object's timer runs out
if (destroyTimer > 0){
	destroyTimer--;	
}
else{
	instance_destroy(self);	
}