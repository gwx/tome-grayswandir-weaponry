local rmm = resolvers.mbonus_material
local rmm100 = function(a, b)
  return rmm(a, b, function(e, v) v = v * 0.01 return 0, v end)
end

local defs = {
  {'FIRE', 'warm', 'burning',},
  {'COLD', 'cool', 'freezing',},
  {'LIGHTNING', 'charged', 'shocking',},
  {'ARCANE', 'enchanted', 'pure',},
  {'PHYSICAL', 'opaque', 'hardened',},
  {'LIGHT', 'transparent', 'clear',},
  {'DARKNESS', 'clouded', 'blackened',},
  {'TEMPORAL', 'old', 'ancient',},
  {'ACID', 'rough', 'acidic',},
  {'BLIGHT', 'cracked', 'foul',},}

for _, d in pairs(defs) do

  newEntity {
    power_source = {arcane = true,},
    name = d[2]..' ', prefix = true, instant_resolve = true,
    keywords = {[d[2]] = true,},
    level_range = {1, 50,},
    rarity = 8,
    cost = 5,
    wielder = {
      combat = {
        resource_strikes = {
          {dam = rmm(8, 2),
           damtype = DamageType[d[1]],},},},},}

  newEntity {
    power_source = {arcane = true,},
    name = d[3]..' ', prefix = true, instant_resolve = true,
    keywords = {[d[3]] = true,},
    level_range = {1, 50,},
    rarity = 11,
    cost = 10,
    wielder = {
      combat = {
        resource_strikes = {
          {burst_on_hit = {
             [DamageType[d[1]]] = rmm(15, 5),},
           damtype = DamageType[d[1]],},},},},}
end
