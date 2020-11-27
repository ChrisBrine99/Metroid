/// @description The state Samus is in when the game first begins and her fanfare is playing. Once the fanfare
/// has completed playing, pressing left or right will change Samus's state to her default.

function state_samus_intro(){
	if ((keyRight && !keyLeft) || (keyLeft && !keyRight)){
		set_cur_state(state_samus_default);
		image_xscale = keyRight - keyLeft;
		return;
	}

	sprite_update(sprStandStart, false);
}