#region Editing default variables, initializing unique variables, and other important initializations

// Edit some of the object's default variables before any initialization of unique variables occurs.
sprite_index = NO_SPRITE;
image_index = 0;
image_speed = 0;
visible = false;

// 32-bits that can each represent their own functionality within any children of this object. However, the 
// top eight bits are reserved for generic flags that are required for an entity to function properly.
stateFlags = 0;

// Variables for keeping track of and manipulating an audio component that can optionally be attached to an
// entity. The first variable stores the pointer to the attached component, whereas the last two variables
// allow the component to be offset from the entity's position based on their respective values.
audioComponent = noone;
audioOffsetX = 0;
audioOffsetY = 0;

// Much like above, this group of variables will keep track of and manipulate a component, but its focus is
// the optional light component that can be attached to an entity. The first variable stores the pointer,
// and the last two store the offset position to place the light at relative to the entity's position.
lightComponent = noone;
lightOffsetX = 0;
lightOffsetY = 0;

// Unused variables that's a holdover from Project Dread since both projects use the same base functionalities.
// interactComponent = noone;

// Variables for animating the current sprite appliex to an entity. They replace the standard built-in animation
// variables like "image_speed" and "image_index" to allow for frame-independent animations. The speed of the
// animation can be manipulated further by changing the value of "animSpeed". Finally, the loop offset determines
// which frame of animation will be the start of the animation; allowing for introduction frames if necessary.
imageIndex = 0;
animSpeed = 0;
spriteLength = 0;
spriteSpeed = 0;
loopOffset = 0;

#endregion