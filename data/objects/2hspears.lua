if config.settings.tome.grayswandir_weaponry_spears ~= false then

  newEntity{
    define_as = 'BASE_GREATSPEAR',
    slot = 'MAINHAND',
    slot_forbid = 'OFFHAND',
    type = 'weapon', subtype='greatspear',
    add_name = ' (#COMBAT#)',
    display = '/', color=colors.SLATE,
		image = 'object/generic_greatspear.png',
    moddable_tile = 'greatspear',
    encumber = 5,
    rarity = 7,
    metallic = true,
    twohanded = true,
    exotic = true,
    ego_bonus_mult = 0.2,
    combat = { talented = 'spear', accuracy_effect = 'knife', damrange = 1.6, physspeed = 1.2, thrust_range = 1, sound = {'actions/melee', pitch=0.7, vol=1.2}, sound_miss = {'actions/melee', pitch=0.7, vol=1.2}},
    desc = [[A heavy spear.]],
    randart_able = '/data/general/objects/random-artifacts/melee.lua',
    egos = '/data-grayswandir-weaponry/egos/2hspears.lua',
    egos_chance = {prefix = resolvers.mbonus(40, 5), suffix = resolvers.mbonus(40, 5),},}

  newEntity{
    base = 'BASE_GREATSPEAR',
    name = 'iron greatspear', short_name = 'iron',
    level_range = {1, 10},
    require = { stat = { str=11 }, },
    cost = 5,
    material_level = 1,
    combat = {
      dam = resolvers.rngavg(13,19),
      apr = 4,
      physcrit = 2.5,
      dammod = {str=1.2},},}

  newEntity{
    base = 'BASE_GREATSPEAR',
    name = 'steel greatspear', short_name = 'steel',
    level_range = {10, 20},
    require = { stat = { str=16 }, },
    cost = 10,
    material_level = 2,
    combat = {
      dam = resolvers.rngavg(20,28),
      apr = 5,
      physcrit = 3,
      dammod = {str=1.2},},}

  newEntity{
    base = 'BASE_GREATSPEAR',
    name = 'dwarven-steel greatspear', short_name = 'd.steel',
    level_range = {20, 30},
    require = { stat = { str=24 }, },
    cost = 15,
    material_level = 3,
    combat = {
      dam = resolvers.rngavg(32,40),
      apr = 6,
      physcrit = 3.5,
      dammod = {str=1.2},},}

  newEntity{
    base = 'BASE_GREATSPEAR',
    name = 'stralite greatspear', short_name = 'stralite',
    level_range = {30, 40},
    require = { stat = { str=35 }, },
    cost = 25,
    material_level = 4,
    combat = {
      dam = resolvers.rngavg(45,52),
      apr = 8,
      physcrit = 4.5,
      dammod = {str=1.2},},}

  newEntity{
    base = 'BASE_GREATSPEAR',
    name = 'voratun greatspear', short_name = 'voratun',
    level_range = {40, 50},
    require = { stat = { str=48 }, },
    cost = 35,
    material_level = 5,
    combat = {
      dam = resolvers.rngavg(58, 66),
      apr = 10,
      physcrit = 5,
      dammod = {str=1.2},},}

end
