-- This file is hooked directly in hooks/objects.lua

if config.settings.tome.grayswandir_weaponry_new_egos ~= false then

	newEntity {
		power_source = {nature = true},
		name = 'tangling ', prefix = true, instant_resolve = true,
		keywords = {tangle = true},
		level_range = {1, 50},
		rarity = 9,
		cost = 10,
		wielder = {
			on_melee_hit = {
				[DamageType.NATURE] = resolvers.mbonus_material(10, 5)},},
		combat = {
			extra_accuracy_effects = {whip = 1},}
	}

	newEntity {
		power_source = {technique = true},
		name = 'piercing ', prefix = true, instant_resolve = true,
		keywords = {pierce = true},
		level_range = {1, 50},
		rarity = 9,
		cost = 5,
		combat = {
			physcrit = resolvers.mbonus_material(6, 2),
			extra_accuracy_effects = {knife = 2},},
	}

	newEntity {
		power_source = {technique = true},
		name = 'crushing ', prefix = true, instant_resolve = true,
		keywords = {crush = true},
		level_range = {1, 50},
		rarity = 9,
		cost = 5,
		combat = {
			dam = resolvers.mbonus_material(6, 2),
			extra_accuracy_effects = {mace = 2},},}

	newEntity {
		power_source = {technique = true},
		name = 'sharp ', prefix = true, instant_resolve = true,
		keywords = {sharp = true},
		level_range = {1, 50},
		rarity = 9,
		cost = 5,
		combat = {
			dam = resolvers.mbonus_material(3, 1),
			physcrit = resolvers.mbonus_material(3, 1),
			extra_accuracy_effects = {sword = 2},},}

	newEntity {
		power_source = {technique = true},
		name = 'cutting ', prefix = true, instant_resolve = true,
		keywords = {cut = true},
		level_range = {1, 50},
		rarity = 9,
		cost = 5,
		combat = {
			dam = resolvers.mbonus_material(3, 1),
			physcrit = resolvers.mbonus_material(3, 1),
			extra_accuracy_effects = {axe = 2},},}

end
