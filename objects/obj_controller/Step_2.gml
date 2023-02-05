// Calling the end step event for all singleton structs that contain an end_step function within their code.
with(CAMERA)				{end_step();}
with(AUDIO_MANAGER)			{end_step();}
with(MUSIC_HANDLER)			{end_step();}
with(TEXTBOX_HANDLER)		{end_step();}

// Call the end step event for all currently existing menu structs, which will handle their next state logic.
var _length = ds_list_size(global.menuInstances);
for (var i = 0; i < _length; i++){
	with(global.menuInstances[| i]) {end_step();}
}

// FOR TESTING
//with(DEBUGGER) {end_step();}
