load('/data/general/objects/egos/shield.lua')

local rmm = resolvers.mbonus_material

newEntity {
	power_source = {psionic = true,},
	name = ' of the shroud', suffix = true, instant_resolve = true,
	keywords = {shroud = true,},
	level_range = {20, 50,},
	greater_ego = 1,
	rarity = 12,
	cost = 14,
	wielder = {
		inc_stealth = rmm(15, 5),
		resists = {
			[DamageType.DARKNESS] = rmm(15, 5),
			[DamageType.MIND] = rmm(15, 5),},
		combat_spellresist = rmm(30, 10),
		combat_mindresist = rmm(30, 10),},}
