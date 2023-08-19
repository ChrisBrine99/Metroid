/// @description A simple graphical effect that shows the destruction and recreation of a destructible object
/// within the game world when it's hit by the proper projectile or weapon used by the player character (Ex.
/// shooting a standard destructible with any projectile, detonating a bomb next to a bomb block, shooting a
/// missile at a missile block, etc.).
/// @param {Real} index		Unique value generated by GML during compilation that represents this struct asset.
function obj_destructible_effect(_index) : base_struct(_index) constructor{
	// Stores the whole-number position of the struct within the current room. Because of how this object works,
	// it should always be the same as the position of the block that created it.
	x = 0;
	y = 0;
	
	// Stores the id of the destructible block that created this struct for its graphical effect. Used when
	// the struct is destroyed in order to clear the variables within that object that store this struct's
	// pointer value.
	parentID = noone;
	
	// Variables that are identical in function to the GML variables "sprite_index", "image_speed", and
	// "image_index", repsectively, with a few extras to store the animation speed of the sprite relative
	// to its predetermined animation rate and the length of the sprite's total frames of animation.
	spriteIndex		= spr_destructible_effect;
	spriteLength	= sprite_get_number(spriteIndex);
	spriteSpeed		= sprite_get_speed(spriteIndex);
	imageIndex		= 0;
	animSpeed		= 0;
	
	/// @description Draws the effect for the destructible block's destruction or rebuild; depending on how
	/// the image index and animation speeds were setup, respectively. It will only animate if the game is
	/// not in its "Paused" state much like how entities animate. The difference here is the effect struct is
	/// destroyed once the animation has reached its start or ending, respectively.
	draw = function(){
		if (GAME_CURRENT_STATE != GSTATE_NORMAL) {return;}
		
		imageIndex += spriteSpeed / ANIMATION_FPS * DELTA_TIME * animSpeed;
		if ((imageIndex < 0 && animSpeed < 0) || (imageIndex >= spriteLength && animSpeed > 0)){
			var _imageIndex = imageIndex;
			with(parentID){
				// Attempt to rebuild the destructible object by calling its "rebuilding" function. If it
				// fails to be rebuilt, a new destruction effect will be created to replace this one's effect.
				if (_imageIndex < 0){
					destructible_rebuild_self();
					return; // Struct is deleted by the above function already; so this function exits early.
				}
				instance_destroy_struct(effectID);
				effectID = noone;
			}
			return; // Prevent the sprite from rendering once its outside its valid image index bounds.
		}
		draw_sprite(spriteIndex, floor(imageIndex), x, y);
	}
}