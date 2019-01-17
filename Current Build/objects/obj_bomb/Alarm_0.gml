/// @description Explode the bomb
// You can write your code in this editor

instance_create_depth(x, y, depth - 50, obj_bomb_explode);
instance_destroy(self);