/// @description Setup the Block's Characteristics
// You can write your code in this editor

// The default for the setObject variable
setObject[0] = noone;
if (blockType == DYNAMIC_BLOCK.NORMAL){ // Destroyed by everything
	setObject[0] = par_projectile;
	setObject[1] = obj_bomb_explode;
	//setObject[2] = obj_pBomb_explode;
} else if (blockType == DYNAMIC_BLOCK.MISSILE){ // Destroyed by the missile and super missile
	setObject[0] = obj_missile;
	setObject[1] = obj_sMissile;
} else if (blockType == DYNAMIC_BLOCK.SUPER_MISSILE){ // Destroyed by super missiles
	setObject[0] = obj_sMissile;
} else if (blockType == DYNAMIC_BLOCK.BOMB){ // Destroyed by bombs and power bombs
	setObject[0] = obj_bomb_explode;
	//setObject[1] = obj_pBomb_explode;
}
entityNum = array_length_1d(setObject);

// Set the tile to cover the block if it is hidden
if (hidden){
	tileMap = layer_tilemap_get_id(layer_get_id("Midground_Tiles"));
	tileData = tilemap_get(tileMap, cellX, cellY);	
}