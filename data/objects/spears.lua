if config.settings.tome.grayswandir_weaponry_spears ~= false then

  newEntity{
    define_as = 'BASE_SPEAR',
    slot = 'MAINHAND', dual_wieldable = true,
    type = 'weapon', subtype='spear',
    add_name = ' (#COMBAT#)',
    display = '/', color=colors.SLATE,
		image = 'object/generic_spear.png',
    moddable_tile = '%s_hand_07',
    encumber = 3,
    rarity = 6,
    metallic = true,
    exotic = true,
    combat = { talented = 'spear', accuracy_effect = 'knife', damrange = 1.4, physspeed = 1.2, thrust_range = 1, sound = {'actions/melee', pitch=0.7, vol=1.2}, sound_miss = {'actions/melee', pitch=0.7, vol=1.2}},
    desc = [[A spear.]],
    randart_able = '/data/general/objects/random-artifacts/melee.lua',
    egos = '/data-grayswandir-weaponry/egos/spears.lua', egos_chance = { prefix=resolvers.mbonus(40, 5), suffix=resolvers.mbonus(40, 5) },
  }

  newEntity{
    base = 'BASE_SPEAR',
    name = 'iron spear', short_name = 'iron',
    level_range = {1, 10},
    require = { stat = { str=11 }, },
    cost = 5,
    material_level = 1,
    combat = {
      dam = resolvers.rngavg(10,13),
      apr = 4,
      physcrit = 2.5,
      dammod = {str=1},
    },
  }

  newEntity{
    base = 'BASE_SPEAR',
    name = 'steel spear', short_name = 'steel',
    level_range = {10, 20},
    require = { stat = { str=16 }, },
    cost = 10,
    material_level = 2,
    combat = {
      dam = resolvers.rngavg(12,18),
      apr = 5,
      physcrit = 3,
      dammod = {str=1},
    },
  }

  newEntity{
    base = 'BASE_SPEAR',
    name = 'dwarven-steel spear', short_name = 'd.steel',
    level_range = {20, 30},
    require = { stat = { str=24 }, },
    cost = 15,
    material_level = 3,
    combat = {
      dam = resolvers.rngavg(20,26),
      apr = 6,
      physcrit = 3.5,
      dammod = {str=1},
    },
  }

  newEntity{
    base = 'BASE_SPEAR',
    name = 'stralite spear', short_name = 'stralite',
    level_range = {30, 40},
    require = { stat = { str=35 }, },
    cost = 25,
    material_level = 4,
    combat = {
      dam = resolvers.rngavg(30,37),
      apr = 8,
      physcrit = 4.5,
      dammod = {str=1},
    },
  }

  newEntity{
    base = 'BASE_SPEAR',
    name = 'voratun spear', short_name = 'voratun',
    level_range = {40, 50},
    require = { stat = { str=48 }, },
    cost = 35,
    material_level = 5,
    combat = {
      dam = resolvers.rngavg(40,45),
      apr = 10,
      physcrit = 5,
      dammod = {str=1},
    },
  }

end
