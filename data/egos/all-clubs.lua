local rmm = resolvers.mbonus_material

if config.settings.tome.grayswandir_weaponry_new_egos ~= false then

	newEntity {
		power_source = {nature = true},
		name = ' of binding', suffix = true, instant_resolve = true,
		keywords = {binding = true},
		level_range = {1, 50},
		rarity = 40,
		cost = 40,
		greater_ego = 1,
		combat = {
			extra_accuracy_effects = {whip = 1,},
			melee_project = {
				NATURE = rmm(30, 10),
				GRAYSWANDIR_BINDING = rmm(12, 8),},},}

end
