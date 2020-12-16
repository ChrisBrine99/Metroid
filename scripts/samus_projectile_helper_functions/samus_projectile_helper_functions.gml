/// @description Helper scripts for Samus's variable projectiles. For now, this file will contain functions for
/// the creation of the correct explosion effect for the respective projectile (or bomb) that called the script.
/// The arguments that handle the explosion effect should NOT have any arguments in them, as they can't be
/// accounted for.

// @description Creates the explosion effect for the stardard bomb.
function samus_bomb_explode(){
	var _effect = instance_create_depth(x, y, depth, obj_samus_projectile_explode);
	_effect.create_explosion(-1, damage, projectileType, spr_bomb_explode, 40, 1, make_color_rgb(125, 125, 255));
}