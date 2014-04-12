load('/data/general/objects/egos/weapon.lua')

-- Make plain weapon egos rarer.
for i, ego in ipairs(loading_list) do
  if ego.rarity then ego.rarity = ego.rarity * 2 end
end

local stat = require 'engine.interface.ActorStats'

newEntity {
  power_source = {technique = true},
  name = 'dextrous ', prefix = true, instant_resolve = true,
  keywords = {swift = true},
  level_range = {1, 50},
  rarity = 3,
  cost = 10,
  combat = {dam = -1,},
  wielder = {
    inc_stats = {
      [stat.STAT_DEX] = resolvers.mbonus_material(3, 1),},
    quick_weapon_swap = 1,},
}

newEntity {
  power_source = {nature = true},
  name = 'luminescent ', prefix = true, instant_resolve = true,
  keywords = {['lum.'] = true},
  level_range = {1, 50},
  rarity = 4,
  cost = 10,
  combat = {
    melee_project = {
      [DamageType.LIGHT] = resolvers.mbonus_material(10, 5),},
    illuminate_power = resolvers.mbonus_material(40, 10),
    special_on_hit = {
      desc = '25% chance to light up the target',
      fct = function(combat, who, target)
        if not rng.percent(25) then return end
        target:setEffect('EFF_LUMINESCENCE', 8, {power = combat.illuminate_power or 20})
    end},},
  wielder = {
    lite = resolvers.mbonus_material(2, 1),},
}

newEntity {
  power_source = {technique = true,},
  name = 'cunning ', prefix = true, instant_resolve = true,
  keywords = {cunning = true,},
  level_range = {1, 50},
  rarity = 5,
  cost = 15,
  combat = {
    physcrit = resolvers.mbonus_material(10, 5),},
  wielder = {
		combat_critical_power = resolvers.mbonus_material(10, 5),
    inc_stats = {
      [stat.STAT_CUN] = resolvers.mbonus_material(6, 1),},},}

newEntity {
  power_source = {technique = true},
  name = ' of finesse', suffix = true, instant_resolve = true,
  keywords = {finesse = true},
  level_range = {25, 50},
  rarity = 18,
  cost = 30,
  combat = {
    accuracy_effect = 'rapid',},}

newEntity {
  power_source = {technique = true},
  name = ' of disarming', suffix = true, instant_resolve = true,
  keywords = {disarming = true},
  level_range = {1, 50},
  rarity = 4,
  cost = 12,
  wielder = {
    combat_def = resolvers.mbonus_material(10, 2),},
  combat = {
    extra_accuracy_effects = {swordbreaker = 1},},}

newEntity {
  power_source = {technique = true},
  name = 'dueling ', prefix = true, instant_resolve = true,
  keywords = {duel = true},
  level_range = {1, 50},
  rarity = 3,
  cost = 12,
  combat = {
    extra_accuracy_effects = {
      duel = {
        power = 1,
        def = resolvers.mbonus_material(4, 2),
        max = resolvers.mbonus_material(40, 20),
        dur = resolvers.mbonus_material(2, 3),},},},
  wielder = {
    inc_stats = {
      [stat.STAT_DEX] = resolvers.mbonus_material(3, 1),},},}

newEntity {
  power_source = {arcane = true},
  name = 'singing ', prefix = true, instant_resolve = true,
  keywords = {singing = true},
  level_range = {25, 50},
  rarity = 30,
  cost = 40,
  greater_ego = 1,
  carrier = {
    inc_stealth = resolvers.mbonus_material(-35, -15),
    taunt_nearby = {
      range = resolvers.mbonus_material(3, 3),
      chance = resolvers.mbonus_material(20, 10),},},
  wielder = {
		combat_physspeed = resolvers.mbonus_material(10, 5, function(e, v) v=v/100 return 0, v end),
		mana_regen = resolvers.mbonus_material(30, 10, function(e, v) v=v/100 return 0, v end),
		silence_immune = resolvers.mbonus_material(30, 20, function(e, v) v=v/100 return 0, v end),},
  combat = {
    extra_accuracy_effects = {staff = 1,},
    burst_on_hit = {
      [DamageType.ARCANE] = resolvers.mbonus_material(30, 10),},},}

newEntity {
  power_source = {technique = true,},
  name = 'very, very sharp ', prefix = true, instant_resolve = true,
  keywords = {['v.v.sharp'] = true},
  level_range = {25, 50},
  rarity = 30,
  cost = 40,
  greater_ego = 1,
  combat = {
    extra_accuracy_effects = {
      sword = resolvers.mbonus(2, 2),
      knife = resolvers.mbonus(2, 2),},
    dam = resolvers.mbonus(7, 3),
    apr = resolvers.mbonus(20, 10),
    physcrit = resolvers.mbonus(10, 5),},}
