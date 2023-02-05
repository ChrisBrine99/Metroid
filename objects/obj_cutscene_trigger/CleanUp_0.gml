// Destroy the data structures that are used within this object. (The cutscene manager doesn't need to delete
// its own "sceneInstructions" variable when a cutscene is finished because it just stores a pointer to this
// list's data, which is destroyed here by the trigger object itself.)
ds_list_destroy(sceneInstructions);
ds_list_destroy(requiredFlags);