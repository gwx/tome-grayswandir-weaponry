if config.settings.tome.grayswandir_weaponry_new_egos ~= false then

	newEntity {
		power_source = {technique = true},
		name = 'heavy ', prefix = true, instant_resolve = true,
		keywords = {heavy = true},
		level_range = {1, 50},
		rarity = 3,
		cost = 10,
		combat = {
			dam = resolvers.mbonus_material(5, 1),},
		encumber = 1,
		granted_abilities = {T_GRAYSWANDIR_HEAVY_STRIKE = true,},}

	newEntity {
		power_source = {technique = true,},
		name = ' of sweeping', suffix = true, instant_resolve = true,
		level_range = {1, 50},
		rarity = 7,
		cost = 20,
		granted_abilities = {T_GRAYSWANDIR_SWEEPING_BLOWS = true,},}

end
