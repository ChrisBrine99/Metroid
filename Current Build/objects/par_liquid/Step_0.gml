/// @description Letting the player get hurt by the liquid again
// You can write your code in this editor

if (damage > 0){
	if (!canHurtSamus){
		damageTimer--;
		if (damageTimer <= 0){
			damageTimer = round(maxDamageTimer / global.damageRes);
			canHurtSamus = true;
		}
	}
}