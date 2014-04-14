local rmm = resolvers.mbonus_material
local rmm100 = function(a, b)
  return rmm(a, b, function(e, v) v = v * 0.01 return 0, v end)
end

local data

data = {
  FIRE = 'warm',
  COLD = 'cool',
  PHYSICAL = 'opaque',
  LIGHTNING = 'charged',
  ACID = 'rough',
  DARKNESS = 'clouded',
  LIGHT = 'trasparent',
  TEMPORAL = 'old',
  BLIGHT = 'cracked',}

for element, name in pairs(data) do
  newEntity {
    power_source = {arcane = true,},
    name = name..' ', prefix = true, instant_resolve = true,
    keywords = {[name] = true,},
    level_range = {1, 50,},
    rarity = 8,
    cost = 5,
    wielder = {
      combat = {
        resource_strikes = {
          {melee_project = {
             [DamageType[element]] = rmm(8, 2),},
           damtype = DamageType[element],},},},},}
end

data = {
  FIRE = 'burning',
  COLD = 'freezing',
  LIGHTNING = 'shocking',
  ACID = 'acidic',
  DARKNESS = 'blackened',
  LIGHT = 'bright',
  TEMPORAL = 'ancient',
  BLIGHT = 'foul',}

for element, name in pairs(data) do
  newEntity {
    power_source = {arcane = true,},
    name = name..' ', prefix = true, instant_resolve = true,
    keywords = {[name] = true,},
    level_range = {1, 50,},
    rarity = 10,
    cost = 11,
    wielder = {
      combat = {
        resource_strikes = {
          {burst_on_hit = {
             [DamageType[element]] = rmm(12, 3),},
           damtype = DamageType[element],},},},},}
end

newEntity {
  power_source = {arcane = true,},
  name = 'chaotic ', prefix = true, instant_resolve = true,
  keywords = {chaotic = true,},
  level_range = {15, 50,},
  rarity = 4,
  cost = 10,
  wielder = {
    inc_damage = {
      [DamageType.FIRE] = rmm(4, 1),
      [DamageType.BLIGHT] = rmm(4, 1),
      [DamageType.PHYSICAL] = rmm(4, 1),},
    combat = {
      resource_strikes = {
        damtype = DamageType.ARCANE,
        {melee_project = {
           [DamageType.FIRE] = rmm(4, 1),
           [DamageType.BLIGHT] = rmm(4, 1),
           [DamageType.PHYSICAL] = rmm(4, 1),},},},},},}
