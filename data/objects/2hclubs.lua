if config.settings.tome.grayswandir_weaponry_clubs ~= false then

  newEntity{
    define_as = 'BASE_GREATCLUB',
    slot = 'MAINHAND',
    slot_forbid = 'OFFHAND',
    type = 'weapon', subtype='greatclub',
    add_name = ' (#COMBAT#)',
    display = '\\', color=colors.LIGHT_RED,
		image = 'object/generic_club.png',
    moddable_tile = resolvers.moddable_tile('2hmace'),
    encumber = 5,
    rarity = 5,
    exotic = true,
    combat = { talented = 'mace', damrange = 1.5, physspeed = 1, sound = {'actions/melee', pitch=0.6, vol=1.2}, sound_miss = {'actions/melee', pitch=0.6, vol=1.2} },
    desc = [[Massive two-handed mauls.]],
    twohanded = true,
    ego_bonus_mult = 0.2,
    randart_able = '/data/general/objects/random-artifacts/melee.lua',
    egos = '/data-grayswandir-weaponry/egos/2hclubs.lua', egos_chance = { prefix=resolvers.mbonus(40, 5), suffix=resolvers.mbonus(40, 5) },
  }

  newEntity{
    base = 'BASE_GREATCLUB',
    name = 'elm greatclub', short_name = 'elm',
    level_range = {1, 10},
    require = { stat = { str=11 }, },
    cost = 5,
    material_level = 1,
    combat = {
      dam = resolvers.rngavg(10,16),
      apr = 1,
      physcrit = 0.5,
      dammod = {str=1.2},
    },
  }

  newEntity{
    base = 'BASE_GREATCLUB',
    name = 'ash greatclub', short_name = 'ash',
    level_range = {10, 20},
    require = { stat = { str=16 }, },
    cost = 10,
    material_level = 2,
    combat = {
      dam = resolvers.rngavg(22,30),
      apr = 2,
      physcrit = 1,
      dammod = {str=1.2},
    },
  }

  newEntity{
    base = 'BASE_GREATCLUB',
    name = 'yew greatclub', short_name = 'yew',
    level_range = {20, 30},
    require = { stat = { str=24 }, },
    cost = 15,
    material_level = 3,
    combat = {
      dam = resolvers.rngavg(38,45),
      apr = 2,
      physcrit = 1.5,
      dammod = {str=1.2},
    },
  }

  newEntity{
    base = 'BASE_GREATCLUB',
    name = 'elven-wood greatclub', short_name = 'e.wood',
    level_range = {30, 40},
    require = { stat = { str=35 }, },
    cost = 25,
    material_level = 4,
    combat = {
      dam = resolvers.rngavg(50,59),
      apr = 3,
      physcrit = 2.5,
      dammod = {str=1.2},
    },
  }

  newEntity{
    base = 'BASE_GREATCLUB',
    name = 'dragonbone greatclub', short_name = 'dragonbone',
    level_range = {40, 50},
    require = { stat = { str=48 }, },
    cost = 35,
    material_level = 5,
    combat = {
      dam = resolvers.rngavg(62, 72),
      apr = 4,
      physcrit = 3,
      dammod = {str=1.2},
    },
  }

end
