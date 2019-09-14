/// @description Insert description here
// You can write your code in this editor

alpha = 0.35;
col = make_color_rgb(255, 255, 255);

var curBackID;
// The 1st layer of stars (No adjustments made)
starsBack = layer_create(300);

// Set up the characteristics for the background star layer
curBackID = layer_background_create(starsBack, spr_star_background);
layer_background_htiled(curBackID, true);
layer_background_vtiled(curBackID, true);

// The 2nd layer of stars (Scaled up to give illusion of depth)
starsMid = layer_create(200);
layer_x(starsMid, 25);
layer_y(starsMid, 78);
curBackID = layer_background_create(starsMid, spr_star_background);

// Set up the characteristics for the midground star layer
layer_background_htiled(curBackID, true);
layer_background_vtiled(curBackID, true);
layer_background_xscale(curBackID, 2);
layer_background_yscale(curBackID, 2);

// The 3rd layer of stars (Scaled up to give illusion of depth)
starsFore = layer_create(100);
layer_x(starsFore, 69);
layer_y(starsFore, 90);

// Set up the characteristics for the foreground star layer
curBackID = layer_background_create(starsFore, spr_star_background);
layer_background_htiled(curBackID, true);
layer_background_vtiled(curBackID, true);
layer_background_xscale(curBackID, 3);
layer_background_yscale(curBackID, 3);