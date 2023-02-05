#region	Editing inherited variables

//
event_inherited();
// 
maxHspdPenalty = 0.4;
maxVspdPenalty = 0.25;
hAccelPenalty = 0.8;
vAccelPenalty = 0.6;
// 
amplitude = 6;
frequency = 0.03;

#endregion

#region Initialize unique variables

// 
surfWater = -1;

// 
liquidLayer = array_create(0, 0);

#endregion 

#region Utility function initialization

/// @description 
/// @param {Asset.GMSprite}	sprite	The sprite to assign to the new layer.
/// @param {Real}			hspd	How fast the layer will move along the x-axis.
/// @param {Real}			vspd	How fast the layer will move along the y-axis.
/// @param {Real}			scale	The stretch or shrink to apply to the base sprite.
/// @param {Real}			alpha	Determines verall visibility of this layer.
liquid_add_layer = function(_sprite, _hspd, _vspd, _scale, _alpha){
	array_set(liquidLayer, array_length(liquidLayer), {
		x :			0,				// "Position" of the top-left pixel that the layer's tiling will start.
		y :			0,
		size :		(16 * _scale),	// Stores the width and height (They should be equal for the sprite used) of the sprite after scaling.
		sprite :	_sprite,
		hspd :		_hspd,
		vspd :		_vspd,
		scale :		_scale,
		alpha :		_alpha,
	});
}

/// @description 
liquid_clear_layers = function(){
	var _length = array_length(liquidLayer);
	for (var i = 0; i < _length; i++) {delete liquidLayer[i];}
}

liquid_add_layer(spr_water, -0.3, -0.03, 2.5, 0.4);
liquid_add_layer(spr_water, 0.07, 0.23, 4.5, 0.25);

#endregion