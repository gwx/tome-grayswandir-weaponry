if config.settings.tome.grayswandir_weaponry_swordbreakers ~= false then

  newEntity{
    define_as = 'BASE_SWORDBREAKER',
    slot = 'MAINHAND', offslot = 'OFFHAND',
    type = 'weapon', subtype='swordbreaker',
    add_name = ' (#COMBAT#)',
    display = '/', color=colors.WHITE, image = resolvers.image_material('knife', 'metal'),
    moddable_tile = resolvers.moddable_tile('dagger'),
    encumber = 1,
    rarity = 7,
    metallic = true,
    exotic = true,
    combat = { talented = 'knife', accuracy_effect = 'swordbreaker', damrange = 1.3, physspeed = 1, sound = {'actions/melee', pitch=1.2, vol=1.2}, sound_miss = {'actions/melee', pitch=1.2, vol=1.2} },
    desc = [[A small blade with many notches along its edge.]],
    ego_bonus_mult = -0.3,
    randart_able = '/data/general/objects/random-artifacts/melee.lua',
    egos = '/data-grayswandir-weaponry/egos/swordbreakers.lua', egos_chance = { prefix=resolvers.mbonus(40, 5), suffix=resolvers.mbonus(40, 5) },
  }

  newEntity{
    base = 'BASE_SWORDBREAKER',
    name = 'iron swordbreaker', short_name = 'iron',
    level_range = {1, 10},
    require = { stat = { dex=11 }, },
    cost = 5,
    material_level = 1,
    combat = {
      dual_deflect = {
        chance = resolvers.rngavg(1, 2),
        dam = resolvers.rngavg(8, 10),},
      dam = resolvers.rngavg(3,4),
      apr = 2,
      physcrit = 0.5,
      dammod = {dex = 0.4, str = 0.4,},
      alt_dammod = {dex = 0.4, {str = 0.4, cun = 0.5},},},
    wielder = {
      combat_def = 2},
  }

  newEntity{
    base = 'BASE_SWORDBREAKER',
    name = 'steel swordbreaker', short_name = 'steel',
    level_range = {10, 20},
    require = { stat = { dex=16 }, },
    cost = 10,
    material_level = 2,
    combat = {
      dual_deflect = {
        chance = resolvers.rngavg(3, 4),
        dam = resolvers.rngavg(16, 20),},
      dam = resolvers.rngavg(5,8),
      apr = 3,
      physcrit = 1,
      dammod = {dex = 0.4, str = 0.4,},
      alt_dammod = {dex = 0.4, {str = 0.4, cun = 0.5},},},
    wielder = {
      combat_def = 4},
  }

  newEntity{
    base = 'BASE_SWORDBREAKER',
    name = 'dwarven-steel swordbreaker', short_name = 'd.steel',
    level_range = {20, 30},
    require = { stat = { dex=24 }, },
    cost = 15,
    material_level = 3,
    combat = {
      dual_deflect = {
        chance = resolvers.rngavg(5, 6),
        dam = resolvers.rngavg(30, 36),},
      dam = resolvers.rngavg(10,15),
      apr = 4,
      physcrit = 1.5,
      dammod = {dex = 0.4, str = 0.4,},
      alt_dammod = {dex = 0.4, {str = 0.4, cun = 0.5},},},
    wielder = {
      combat_def = 6},
  }

  newEntity{
    base = 'BASE_SWORDBREAKER',
    name = 'stralite swordbreaker', short_name = 'stralite',
    level_range = {30, 40},
    require = { stat = { dex=35 }, },
    cost = 25,
    material_level = 4,
    combat = {
      dual_deflect = {
        chance = resolvers.rngavg(7, 8),
        dam = resolvers.rngavg(40, 48),},
      dam = resolvers.rngavg(17,20),
      apr = 5,
      physcrit = 2.5,
      dammod = {dex = 0.4, str = 0.4,},
      alt_dammod = {dex = 0.4, {str = 0.4, cun = 0.5},},},
    wielder = {
      combat_def = 8},
  }

  newEntity{
    base = 'BASE_SWORDBREAKER',
    name = 'voratun swordbreaker', short_name = 'voratun',
    level_range = {40, 50},
    require = { stat = { dex=48 }, },
    cost = 35,
    material_level = 5,
    combat = {
      dual_deflect = {
        chance = resolvers.rngavg(9, 10),
        dam = resolvers.rngavg(54, 64),},
      dam = resolvers.rngavg(24,27),
      apr = 6,
      physcrit = 3,
      dammod = {dex = 0.4, str = 0.4,},
      alt_dammod = {dex = 0.4, {str = 0.4, cun = 0.5},},},
    wielder = {
      combat_def = 10},
  }

end
