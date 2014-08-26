load('/data/general/objects/egos/weapon.lua')

if config.settings.tome.grayswandir_weaponry_new_egos ~= false then

	newEntity {
		power_source = {antimagic = true},
		name = ' of throat slitting', suffix = true, instant_resolve = true,
		keywords = {slitting = true},
		level_range = {10, 50},
		rarity = 16,
		cost = 30,
		greater_ego = 1,
		combat = {
			melee_project = {
				[DamageType.BLEED] = resolvers.mbonus_material(15, 5),},},
		wielder = {
			inc_stealth = resolvers.mbonus_material(15, 5),
			combat_critical_power = resolvers.mbonus_material(15, 5),},
		granted_abilities = {T_GRAYSWANDIR_THROAT_SLITTER = true,},}

end
