if config.settings.tome.grayswandir_weaponry_new_egos ~= false then

	newEntity {
		power_source = {arcane = true},
		name = 'paladin\'s ', prefix = true, instant_resolve = true,
		keywords = {paladin = true},
		level_range = {20, 50},
		rarity = 20,
		cost = 25,
		greater_ego = 1,
		wielder = {
			resists_pen = {
				[DamageType.LIGHT] = resolvers.mbonus_material(10, 5),},},
		combat = {
			convert_damage = {
				[DamageType.LIGHT] = resolvers.mbonus_material(25, 25),},
			burst_on_hit = {
				[DamageType.LIGHT] = resolvers.mbonus_material(15, 5),},},}

end
