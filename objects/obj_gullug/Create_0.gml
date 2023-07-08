#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();

// Since te Power Beam deals a single point of damage (On "Normal" difficulty), the Gullug will be able to take
// four hits before dying.
maxHitpoints = 4;
hitpoints = maxHitpoints;

// 
energyDropChance = 0.3;		// 35%
aeionDropChance = 0.2;		// 20%
ammoDropChance = 0.2;		// 20%

#endregion