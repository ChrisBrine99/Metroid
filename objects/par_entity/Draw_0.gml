/// @description Standard Entity Drawing and Animation

// Animate based on the sprites speed in frames per second relative to delta time
if (transitionSprite == -1){ // No transition is occuring; display the set sprite
	sprite_index = spriteIndex;
	curFrame += (spriteSpeed / ANIMATION_FPS) * global.deltaTime;
	if (curFrame >= spriteNumber){ // Looping back to the beginning of the sprite
		curFrame = 0;
	}
} else{ // A transition if occuring; let it finish before changing to the standard sprite
	sprite_index = transitionSprite;
	curFrame += (transitionSpeed / ANIMATION_FPS) * global.deltaTime;
	if (curFrame >= transitionNumber){ // Ending the transition
		transitionSprite = -1;
		curFrame = 0;
	}
}

// Finally, draw the entity's current sprite and frame within that sprite
draw_sprite_ext(sprite_index, curFrame, x, y, image_xscale, image_yscale, direction, image_blend, image_alpha);