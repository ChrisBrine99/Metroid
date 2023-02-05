/// @description A struct for the feathering shader, which will store the uniform locations for the two main
/// uniform variables; allowing any object to reference them without having to create variables of their own
/// to store those uniforms.

#region Initializing any macros that are useful/related to the feathering shader

// A macro to simplify the look of the code whenever the feathering shader struct needs to be referenced.
#macro	SHADER_FEATHERING		global.shaderFeathering

#endregion

#region Initializing enumerators that are useful/related to the feathering shader
#endregion

#region Initializing any globals that are useful/related to the feathering shader
#endregion

#region The main object code for the feathering shader

global.shaderFeathering = {
	sFadeStart :		shader_get_uniform(shd_feathering, "fadeStart"),
	sFadeEnd :			shader_get_uniform(shd_feathering, "fadeEnd"),
}

#endregion

#region Global functions related to the feathering shader

/// @description Assigns the bounds for the feathering shader's bounds for the beginning and ending of the
/// effect on the screen. The "end" of the region means that anything draw in the area found outside of this
/// region will have an alpha of 0.
/// @param {Real}	x1	Leftmost edge for the region that isn't feathered.
/// @param {Real}	y1	Topmost edge for the region that isn't feathered.
/// @param {Real}	x2	Rightmost edge for the region that isn't feathered.
/// @param {Real}	y2	Bottommost edge for the region that isn't feathered.
/// @param {Real}	x3	Leftmost edge for the end of the feathered region.
/// @param {Real}	y3	Topmost edge for the end of the feathered region.
/// @param {Real}	x4	Rightmost edge for the end of the feathered region.
/// @param {Real}	y4	Bottommost edge for the end of the feathered region.
function feathering_set_bounds(_x1, _y1, _x2, _y2, _x3, _y3, _x4, _y4){
	with(global.shaderFeathering){
		shader_set_uniform_f(sFadeStart, _x1, _y1, _x2, _y2);
		shader_set_uniform_f(sFadeEnd, _x3, _y3, _x4, _y4);
	}
}

#endregion