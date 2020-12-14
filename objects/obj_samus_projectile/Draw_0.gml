/// @description Drawing the Projectile Using a Simplified Version of the par_entity Draw Event

if (projectileAnimates){
	curFrame += (spriteSpeed / ANIMATION_FPS) * global.deltaTime;
	if (curFrame >= spriteNumber){ // Looping back to the beginning of the sprite
		curFrame = 0;
	}
}

// Finally, draw the entity's current sprite and frame within that sprite
draw_sprite_ext(sprite_index, curFrame, x, y, image_xscale, image_yscale, direction, image_blend, image_alpha);