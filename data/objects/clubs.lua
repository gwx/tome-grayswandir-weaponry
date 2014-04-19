if config.settings.tome.grayswandir_weaponry_clubs ~= false then

  newEntity{
    define_as = 'BASE_CLUB',
    slot = 'MAINHAND', dual_wieldable = true,
    type = 'weapon', subtype='club',
    add_name = ' (#COMBAT#)',
    display = '/', color=colors.LIGHT_RED,
		image = 'object/generic_club.png',
    moddable_tile = resolvers.moddable_tile('mace'),
    encumber = 3,
    rarity = 7,
    exotic = true,
    combat = { talented = 'mace', damrange = 1.4, physspeed = 1, sound = {'actions/melee', pitch=0.6, vol=1.2}, sound_miss = {'actions/melee', pitch=0.6, vol=1.2}},
    desc = [[Blunt and deadly.]],
    randart_able = '/data/general/objects/random-artifacts/generic.lua',
    egos = '/data-grayswandir-weaponry/egos/clubs.lua',
		egos_chance = {prefix = resolvers.mbonus(40, 5), suffix = resolvers.mbonus(40, 5),},
  }

  newEntity{
    base = 'BASE_CLUB',
    name = 'elm club', short_name = 'elm',
    level_range = {1, 10},
    require = { stat = { str=11 }, },
    cost = 5,
    material_level = 1,
    combat = {
      dam = resolvers.rngavg(6,9),
      apr = 2,
      physcrit = 0.5,
      dammod = {str=1},
    },
  }

  newEntity{
    base = 'BASE_CLUB',
    name = 'ash club', short_name = 'ash',
    level_range = {10, 20},
    require = { stat = { str=16 }, },
    cost = 10,
    material_level = 2,
    combat = {
      dam = resolvers.rngavg(11,17),
      apr = 3,
      physcrit = 1,
      dammod = {str=1},
    },
  }

  newEntity{
    base = 'BASE_CLUB',
    name = 'yew club', short_name = 'yew',
    level_range = {20, 30},
    require = { stat = { str=24 }, },
    cost = 15,
    material_level = 3,
    combat = {
      dam = resolvers.rngavg(22,28),
      apr = 4,
      physcrit = 1.5,
      dammod = {str=1},
    },
  }

  newEntity{
    base = 'BASE_CLUB',
    name = 'elven-wood club', short_name = 'e.wood',
    level_range = {30, 40},
    require = { stat = { str=35 }, },
    cost = 25,
    material_level = 4,
    combat = {
      dam = resolvers.rngavg(33,40),
      apr = 5,
      physcrit = 2.5,
      dammod = {str=1},
    },
  }

  newEntity{
    base = 'BASE_MACE',
    name = 'dragonbone club', short_name = 'dragonbone',
    level_range = {40, 50},
    require = { stat = { str=48 }, },
    cost = 35,
    material_level = 5,
    combat = {
      dam = resolvers.rngavg(43,48),
      apr = 6,
      physcrit = 3,
      dammod = {str=1},
    },
  }

end
