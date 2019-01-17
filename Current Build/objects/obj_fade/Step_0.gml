/// @description Handling the fading out and in
// You can write your code in this editor

if (setAlpha < 1 && fade = 0){
	setAlpha += 0.05;
}
if (setAlpha > 0 && opaqueTimer = 0 && fade = 1){
	setAlpha -= 0.05;
	if (setAlpha = 0) instance_destroy(self);
}
    
if (setAlpha == 1){
    fade = 1;
    if (opaqueTimer > 0){
        opaqueTimer--;
    }
}