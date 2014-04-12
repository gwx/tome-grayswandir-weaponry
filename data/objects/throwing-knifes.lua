if config.settings.tome.grayswandir_weaponry_throwing_knives ~= false then

  newEntity{
    define_as = 'BASE_THROWKNIFE',
    slot = 'MAINHAND', offslot = 'OFFHAND',
    type = 'weapon', subtype='throwing knife',
    add_name = ' (#COMBAT_AMMO#)',
    display = '/', color=colors.WHITE, image = resolvers.image_material('knife', 'metal'),
    encumber = 3,
    rarity = 8,
    metallic = true,
    is_own_ammo = true,
    archery = 'knife', archery_kind = 'knife', archery_ammo = 'knife',
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
      capacity = resolvers.rngavg(3, 6),
      dam = resolvers.rngavg(3, 5),
      apr = 5,
      physcrit = 4,
      dammod = {str = 0.45, dex = 0.45},
      alt_dammod = {{str = 0.45, cun = 0.45}, dex = 0.45,},},}

end
