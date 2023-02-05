// Updating all of the singleton structs that contain a step function within their code.
with(EFFECT_HANDLER)		{step();}
with(CUTSCENE_MANAGER)		{step();}
with(TEXTBOX_HANDLER)		{step();}
with(CONTROL_INFO)			{step();}
with(SCREEN_FADE)			{step();}
with(GAMEPAD_MANAGER)		{step();}

// Update all of the existing light sources to handle their optional functionalities of lifespans and flicker.
var _length = ds_list_size(global.lightSources);
for (var l = 0; l < _length; l++){
	with(global.lightSources[| l]) {step();}
}

// Loop through all of the currently existing menus and execute their step events, which handle player input,
// animations, and menu cursor movement logic.
_length = ds_list_size(global.menuInstances);
for (var i = 0; i < _length; i++){
	with(global.menuInstances[| i]) {step();}
}