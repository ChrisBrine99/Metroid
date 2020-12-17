/// @description Insert description here
// You can write your code in this editor

if (isHit){
	return;	
}

recoveryTimer = timeToRecover;
isHit = true;
if (script_exists(hitScript)){ // An optional script the entity can execute when hit
	script_execute(hitScript);
}