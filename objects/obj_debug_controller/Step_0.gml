/// @description Insert description here
// You can write your code in this editor

var isVisible;
isVisible = obj_camera.isVisible;

// Fading the Debug Menu in and out
if (isVisible && !fadeDestroy){
	alpha += 0.2;
	if (alpha > 1){
		alpha = 1;	
	}
} else{
	alpha -= 0.2;
	if (alpha < 0){
		alpha = 0;	
		if (fadeDestroy) {instance_destroy(self);}
	}
}