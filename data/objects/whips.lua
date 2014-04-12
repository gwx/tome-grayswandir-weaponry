if config.settings.tome.grayswandir_weaponry_whips ~= false then

  local base = loading_list['BASE_WHIP']
  base.egos = '/data-grayswandir-weaponry/egos/whips.lua'
  base.rarity = 7
  base.exotic = true
  base.desc = 'A long, leather whip.'
  base.combat.accuracy_effect = 'whip'

  newEntity{
    base = 'BASE_WHIP',
    name = 'rough leather whip', short_name = 'rough',
    level_range = {1, 10},
    require = { stat = { dex=11 }, },
    cost = 10,
    material_level = 1,
    combat = {
      dam = resolvers.rngavg(4,6),
      apr = 0,
      physcrit = 3,
      dammod = {dex=1},
    },
  }

  newEntity{
    base = 'BASE_WHIP',
    name = 'cured leather whip', short_name = 'cured',
    level_range = {10, 20},
    require = {stat = {dex = 16},},
    cost = 20,
    material_level = 2,
    combat = {
      dam = resolvers.rngavg(8,12),
      apr = 1,
      physcrit = 4,
      dammod = {dex=1},
    },
  }

  newEntity{
    base = 'BASE_WHIP',
    name = 'hardened leather whip', short_name = 'hardened',
    level_range = {20, 30},
    require = {stat = {dex = 24},},
    cost = 30,
    material_level = 3,
    combat = {
      dam = resolvers.rngavg(14,22),
      apr = 2,
      physcrit = 5,
      dammod = {dex=1},
    },
  }

  newEntity{
    base = 'BASE_WHIP',
    name = 'reinforced leather whip', short_name = 'reinforced',
    level_range = {30, 40},
    require = {stat = {dex = 35},},
    cost = 50,
    material_level = 4,
    combat = {
      dam = resolvers.rngavg(25,32),
      apr = 3,
      physcrit = 7,
      dammod = {dex=1},
    },
  }

  newEntity{
    base = 'BASE_WHIP',
    name = 'drakeskin leather whip', short_name = 'drakeskin',
    level_range = {40, 50},
    require = {stat = {dex = 48},},
    cost = 70,
    material_level = 5,
    combat = {
      dam = resolvers.rngavg(36,40),
      apr = 4,
      physcrit = 8,
      dammod = {dex = 1},
    },
  }

end
