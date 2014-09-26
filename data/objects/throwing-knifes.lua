if config.settings.tome.grayswandir_weaponry_throwing_knives ~= false then

  newEntity{
    define_as = 'BASE_THROWKNIFE',
    slot = 'MAINHAND', offslot = 'OFFHAND',
    type = 'weapon', subtype='throwing knives',
    add_name = ' (#COMBAT_AMMO#)',
    display = '/', color=colors.WHITE,
		image = 'object/generic_throwing_dagger.png',
    moddable_tile = '%s_throwing_dagger',
    encumber = 3,
    rarity = 8,
    metallic = true,
    exotic = true,
    is_own_ammo = true,
    archery_kind = 'knife', archery_ammo = 'knife',
    archery = false, -- Can also melee hit.
    combat = {
      talented = 'knife',
      damrange = 1.3,
      physspeed = 1,
      sound = {"actions/melee", pitch=1.2, vol=1.2},
      sound_miss = {"actions/melee", pitch=1.2, vol=1.2}
    },
    -- proj_image = resolvers.image_material('arrow', 'wood'),
    proj_image = resolvers.image_material('knife', 'metal'),
    desc = [[These knives are specially weighted to be thrown.]],
    randart_able = '/data/general/objects/random-artifacts/ammo.lua',
    egos = '/data-grayswandir-weaponry/egos/throwing-knifes.lua',
    egos_chance = {prefix = resolvers.mbonus(40, 5), suffix = resolvers.mbonus(40, 5),},
    resolvers.shooter_capacity(),}

  newEntity{
    base = "BASE_THROWKNIFE",
    name = "iron throwing knives", short_name = "iron",
    level_range = {1, 10},
    require = {stat = {dex = 11},},
    cost = 7,
    material_level = 1,
    combat = {
      range = 3,
      capacity = resolvers.rngavg(2, 7),
      dam = resolvers.rngavg(8, 10),
      apr = 5,
      physcrit = 4,
      dammod = {str = 0.45, dex = 0.45},
      alt_dammod = {{str = 0.45, cun = 0.45}, dex = 0.45,},},}

  newEntity{
    base = "BASE_THROWKNIFE",
    name = "steel throwing knives", short_name = "steel",
    level_range = {10, 20},
    require = {stat = {dex = 16},},
    cost = 12,
    material_level = 2,
    combat = {
      range = 3,
      capacity = resolvers.rngavg(3, 7),
      dam = resolvers.rngavg(8, 12),
      apr = 6,
      physcrit = 5,
      dammod = {str = 0.45, dex = 0.45},
      alt_dammod = {{str = 0.45, cun = 0.45}, dex = 0.45,},},}

  newEntity{
    base = "BASE_THROWKNIFE",
    name = "dwarven-steel throwing knives", short_name = "d.steel",
    level_range = {20, 30},
    require = {stat = {dex = 24,},},
    cost = 18,
    material_level = 3,
    combat = {
      range = 4,
      capacity = resolvers.rngavg(4, 7),
      dam = resolvers.rngavg(11, 19),
      apr = 7,
      physcrit = 6,
      dammod = {str = 0.45, dex = 0.45},
      alt_dammod = {{str = 0.45, cun = 0.45}, dex = 0.45,},},}

  newEntity{
    base = "BASE_THROWKNIFE",
    name = "stralite throwing knives", short_name = "stralite",
    level_range = {30, 40},
    require = {stat = {dex = 35},},
    cost = 29,
    material_level = 4,
    combat = {
      range = 4,
      capacity = resolvers.rngavg(5, 7),
      dam = resolvers.rngavg(3, 5),
      apr = 9,
      physcrit = 8,
      dammod = {str = 0.45, dex = 0.45},
      alt_dammod = {{str = 0.45, cun = 0.45}, dex = 0.45,},},}

  newEntity{
    base = "BASE_THROWKNIFE",
    name = "voratun throwing knives", short_name = "voratun",
    level_range = {40, 50},
    require = {stat = {dex = 48},},
    cost = 40,
    material_level = 5,
    combat = {
      range = 5,
      capacity = resolvers.rngavg(6, 7),
      dam = resolvers.rngavg(31, 35),
      apr = 9,
      physcrit = 10,
      dammod = {str = 0.45, dex = 0.45},
      alt_dammod = {{str = 0.45, cun = 0.45}, dex = 0.45,},},}

end
