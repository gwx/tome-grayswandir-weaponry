load('/data/general/objects/egos/weapon.lua')

if config.settings.tome.grayswandir_weaponry_new_egos ~= false then

	newEntity {
		power_source = {technique = true},
		name = ' of tripping', suffix = true, instant_resolve = true,
		keywords = {trip = true},
		level_range = {1, 50},
		rarity = 3,
		cost = 10,
		wielder = {
			combat_atk = resolvers.mbonus_material(7, 3),},
		combat = {
			melee_project = {
				[DamageType.GRAYSWANDIR_TRIP] = resolvers.mbonus_material(40, 20),},},
	}

	newEntity {
		power_source = {nature = true},
		name = 'thorned ', prefix = true, instant_resolve = true,
		keywords = {thorn = true},
		level_range = {1, 50},
		rarity = 4,
		cost = 14,
		wielder = {
			combat_atk = resolvers.mbonus_material(7, 3),},
		combat = {
			apr = resolvers.mbonus_material(10, 3),
			melee_project = {
				[DamageType.POISON] = resolvers.mbonus_material(15, 5),
				[DamageType.BLEED] = resolvers.mbonus_material(15, 5),},},
	}

end
