loading_list.BASE_LONGSWORD.egos = '/data-grayswandir-weaponry/egos/swords.lua'
for i, e in ipairs(loading_list) do
  if e.subtype == 'longsword' then e.egos = '/data-grayswandir-weaponry/egos/swords.lua' end
end

if config.settings.tome.grayswandir_weaponry_rapiers ~= false then

  newEntity{
    define_as = "BASE_RAPIER",
    slot = "MAINHAND", dual_wieldable = true,
    type = "weapon", subtype="rapier",
    add_name = " (#COMBAT#)",
    display = "/", color=colors.SLATE, image = resolvers.image_material("sword", "metal"),
    moddable_tile = resolvers.moddable_tile("sword"),
    encumber = 2.5,
    rarity = 7,
    metallic = true,
    exotic = true,
    combat = { talented = "knife", accuracy_effect = "sword", damrange = 1.3, physspeed = 1, sound = {"actions/melee", pitch=0.6, vol=1.2}, sound_miss = {"actions/melee", pitch=0.6, vol=1.2}},
    desc = [[A light sword.]],
    randart_able = "/data/general/objects/random-artifacts/melee.lua",
    egos = "/data-grayswandir-weaponry/egos/rapiers.lua", egos_chance = { prefix=resolvers.mbonus(40, 5), suffix=resolvers.mbonus(40, 5) },
  }

  newEntity{
    base = "BASE_RAPIER",
    name = "iron rapier", short_name = "iron",
    level_range = {1, 10},
    require = {stat = {str = 10, dex = 10,},},
    alt_requires = {{stat = {cun = 10, dex = 10,},}},
    cost = 5,
    material_level = 1,
    combat = {
      dam = resolvers.rngavg(5,7),
      apr = 2,
      physcrit = 4,
      dammod = {str = 0.4, dex = 0.4, cun = 0.4},
    },
  }

  newEntity{
    base = "BASE_RAPIER",
    name = "steel rapier", short_name = "steel",
    level_range = {10, 20},
    require = {stat = {str = 14, dex = 14,},},
    alt_requires = {{stat = {cun = 14, dex = 14,},}},
    cost = 10,
    material_level = 2,
    combat = {
      dam = resolvers.rngavg(10,15),
      apr = 3,
      physcrit = 5,
      dammod = {str = 0.4, dex = 0.4, cun = 0.4},
    },
  }

  newEntity{
    base = "BASE_RAPIER",
    name = "dwarven-steel rapier", short_name = "d.steel",
    level_range = {20, 30},
    require = {stat = {str = 20, dex = 20,},},
    alt_requires = {{stat = {cun = 20, dex = 20,},}},
    cost = 15,
    material_level = 3,
    combat = {
      dam = resolvers.rngavg(20,25),
      apr = 4,
      physcrit = 6,
      dammod = {str = 0.4, dex = 0.4, cun = 0.4},
    },
  }

  newEntity{
    base = "BASE_RAPIER",
    name = "stralite rapier", short_name = "stralite",
    level_range = {30, 40},
    require = {stat = {str = 28, dex = 28,},},
    alt_requires = {{stat = {cun = 28, dex = 28,},}},
    cost = 25,
    material_level = 4,
    combat = {
      dam = resolvers.rngavg(30,36),
      apr = 5,
      physcrit = 8,
      dammod = {str = 0.4, dex = 0.4, cun = 0.4},
    },
  }

  newEntity{
    base = "BASE_RAPIER",
    name = "voratun rapier", short_name = "voratun",
    level_range = {40, 50},
    require = {stat = {str = 38, dex = 38,},},
    alt_requires = {{stat = {cun = 38, dex = 38,},}},
    cost = 35,
    material_level = 5,
    combat = {
      dam = resolvers.rngavg(40,44),
      apr = 6,
      physcrit = 10,
      dammod = {str = 0.4, dex = 0.4, cun = 0.4},
    },
  }

end
