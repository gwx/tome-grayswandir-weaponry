if config.settings.tome.grayswandir_weaponry_bucklers ~= false then

	newEntity{
		define_as = 'BASE_BUCKLER',
		slot = 'OFFHAND',
		type = 'armor', subtype='buckler',
		--add_name = ' (#ARMOR#, #SHIELD#)',
		display = ')', color=colors.UMBER, image = resolvers.image_material('shield', 'metal'),
		moddable_tile = resolvers.moddable_tile('shield'),
		rarity = 7,
		encumber = 3,
		metallic = true,
		desc = [[Small handheld shield used for deflecting blows and misdirecting opponents.]],
		randart_able = '/data/general/objects/random-artifacts/shields.lua',
		special_combat = {talented='buckler', accuracy_effect='axe', damrange = 1.1,},
    egos = '/data-grayswandir-weaponry/egos/bucklers.lua',
		egos_chance = {prefix = resolvers.mbonus(40, 5), suffix = resolvers.mbonus(40, 5),},
	}

	-- All bucklers have a 'special_combat' field, this is used to compute
	-- damage made with them when using special talents

	newEntity {
		base = 'BASE_BUCKLER',
		name = 'iron buckler', short_name = 'iron',
		level_range = {1, 10},
		require = {stat = {str = 10, dex = 10,},},
		alt_requires = {{stat = {cun = 10, dex = 10,},}},
		cost = 5,
		material_level = 1,
		special_combat = {
			dam = resolvers.rngavg(5, 7),
			block = resolvers.rngavg(15, 25),
			physcrit = 1,
			dammod = {str = 0.4, dex = 0.4, cun = 0.4,},},
		wielder = {
			combat_physcrit = 1.5,
			combat_def = 4,
			fatigue = 3,
			learn_talent = {T_GRAYSWANDIR_GUARD = 1,},},}

	newEntity {
		base = 'BASE_BUCKLER',
		name = 'steel buckler', short_name = 'steel',
		level_range = {10, 20},
		require = {stat = {str = 14, dex = 14,},},
		alt_requires = {{stat = {cun = 14, dex = 14,},}},
		cost = 10,
		material_level = 2,
		special_combat = {
			dam = resolvers.rngavg(10, 15),
			physcrit = 1.5,
			dammod = {str = 0.4, dex = 0.4, cun = 0.4,},},
		wielder = {
			combat_physcrit = 3,
			combat_def = 6,
			fatigue = 4,
			learn_talent = {T_GRAYSWANDIR_GUARD = 2,},},}

	newEntity {
		base = 'BASE_BUCKLER',
		name = 'dwarven-steel buckler', short_name = 'd.steel',
		level_range = {20, 30},
		require = {stat = {str = 20, dex = 20,},},
		alt_requires = {{stat = {cun = 20, dex = 20,},}},
		cost = 15,
		material_level = 3,
		special_combat = {
			dam = resolvers.rngavg(20, 25),
			physcrit = 2,
			dammod = {str = 0.4, dex = 0.4, cun = 0.4,},},
		wielder = {
			combat_physcrit = 4.5,
			combat_def = 8,
			fatigue = 6,
			learn_talent = {T_GRAYSWANDIR_GUARD = 3,},},}

	newEntity {
		base = 'BASE_BUCKLER',
		name = 'stralite buckler', short_name = 'stralite',
		level_range = {30, 40},
		require = {stat = {str = 28, dex = 28,},},
		alt_requires = {{stat = {cun = 28, dex = 28,},}},
		cost = 25,
		material_level = 4,
		special_combat = {
			dam = resolvers.rngavg(30, 36),
			physcrit = 2.5,
			dammod = {str = 0.4, dex = 0.4, cun = 0.4,},},
		wielder = {
			combat_physcrit = 6,
			combat_def = 10,
			fatigue = 7,
			learn_talent = {T_GRAYSWANDIR_GUARD = 4,},},}

	newEntity {
		base = 'BASE_BUCKLER',
		name = 'voratun buckler', short_name = 'voratun',
		level_range = {40, 50},
		require = {stat = {str = 38, dex = 38,},},
		alt_requires = {{stat = {cun = 38, dex = 38,},}},
		cost = 35,
		material_level = 5,
		special_combat = {
			dam = resolvers.rngavg(40, 44),
			physcrit = 3,
			dammod = {str = 0.4, dex = 0.4, cun = 0.4,},},
		wielder = {
			combat_physcrit = 7.5,
			combat_def = 12,
			fatigue = 7,
			learn_talent = {T_GRAYSWANDIR_GUARD = 5,},},}

end
