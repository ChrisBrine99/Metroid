/// @description Draw Screen-Space Effects

// The screen-space post processing effects are ordered as follows:
//		1	--		Film Grain/Noise
//		2	--		Scanlines

// TODO -- Add check to see if noise filter is enabled
//film_grain_effect(filmGrainWidth, 0.09, 4);

// TODO -- Add check to see if scanline effect is enabled
scanline_effect(WINDOW_HEIGHT, 0.1);