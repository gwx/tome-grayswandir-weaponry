local rmm = resolvers.mbonus_material
local rmm100 = function(a, b)
  return rmm(a, b, function(e, v) v = v * 0.01 return 0, v end)
end

local defs = {
  {'FIRE', 'warm', 'garnet', 'burning', 'ruby',},
  {'COLD', 'cool', 'lapis_lazuli', 'freezing', 'sapphire',},
  {'LIGHTNING', 'charged', 'fireopal', 'shocking', 'topaz',},
  {'ARCANE', 'enchanted', 'amethyst', 'pure', 'pearl',},
  {'PHYSICAL', 'opaque', 'agate', 'hardened', 'aquamarine',},
  {'LIGHT', 'transparent', 'quartz', 'clear', 'zircon',},
  {'DARKNESS', 'clouded', 'ametrine', 'blackened', 'onyx',},
  {'TEMPORAL', 'old', 'turquoise', 'ancient', 'jade',},
  {'ACID', 'rough', 'amber', 'acidic', 'emerald',},
  {'BLIGHT', 'cracked', 'spinel', 'foul', 'bloodstone',},}

for _, d in pairs(defs) do

  newEntity {
    power_source = {arcane = true,},
    name = d[2]..' ', prefix = true, instant_resolve = true,
    keywords = {[d[2]] = true,},
    level_range = {1, 50,},
    rarity = 8,
    cost = 5,
    --image = 'object/'..d[3]..'.png',
    wielder = {
      combat = {
        resource_strikes = {
          {dam = rmm(8, 2),
           damtype = DamageType[d[1]],},},},},}

  newEntity {
    power_source = {arcane = true,},
    name = d[4]..' ', prefix = true, instant_resolve = true,
    keywords = {[d[4]] = true,},
    level_range = {1, 50,},
    rarity = 11,
    cost = 10,
    --image = 'object/'..d[5]..'.png',
    wielder = {
      combat = {
        resource_strikes = {
          {burst_on_hit = {
             [DamageType[d[1]]] = rmm(15, 5),},
           damtype = DamageType[d[1]],},},},},}
end
