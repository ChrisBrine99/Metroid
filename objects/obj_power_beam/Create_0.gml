/// @description Variable Initialization

#region EDITING INHERITED VARIABLES

// Call the par_entity_projectile parent event to initialize all variables to their defaults
event_inherited();
// Set the maximum speeds both axes
set_max_move_speed(9, 9, true);
// Set the damage of the power beam
damage = 1;
// The power beam will be destroyed by both entities and walls
destroyOnWallCollide = true;
destroyOnEntityCollide = true;
// Finally, this projectile was fired by Samus, so it won't hurt her
projectileType = Weapon.PowerBeam;

#endregion