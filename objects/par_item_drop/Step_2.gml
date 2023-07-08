// Updating the light source's properties (IF A LIGHT SOURCE EXISTS FOR THE GIVEN COLLECTIBLE) so it gets dimmer 
// and brighter at the same rate as the collectible animates between its dim and bright images, respectively.
if (lightComponent != noone){
	var _imageIndex		= floor(imageIndex);
	var _baseRadius		= baseRadius;
	var _baseStrength	= baseStrength;
	with(lightComponent){
		if (_imageIndex == 1) {set_properties(_baseRadius, color, _baseStrength);}
		else {set_properties(round(_baseRadius * 1.3), color, _baseStrength * 1.3);}
	}
}