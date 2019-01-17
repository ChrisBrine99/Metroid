/// @description Drawing a hidden block or the block itself
// You can write your code in this editor

if (!beenHit){
	if (hidden) draw_sprite(spr_dBlock_hidden, setIndex, x, y);
	else draw_self();
}
