if (!IS_ON_SCREEN) {return;}
global.drawnEntities++;

// Render the block regeneration/destruction effect if it exists; skipping over rendering the block itself during
// that process to avoid any weird issues with both rendering in the same frame without the "return" statement. 
with(effectID){
	draw();
	return;
}

// If no effect currently exists, the destructible block will be rendered (If it can be rendered) in one of two
// ways: either a tile from the current area in order to hide the block within the game's world, or just the block
// itself if it isn't hidden or was unveiled by the player's interaction with the block.
if (CAN_DRAW_SPRITE && sprite_index != NO_SPRITE){
	if (IS_HIDDEN && tileset != -1 && tiledata != -1){
		draw_tile(tileset, tiledata, 0, x, y);
		return; // Don't bother drawing the block itself below the tile that is hiding it.
	}
	draw_self();
}