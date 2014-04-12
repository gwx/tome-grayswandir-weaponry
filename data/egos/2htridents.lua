load('/data-grayswandir-weaponry/egos/2hweapons.lua')
load('/data/general/objects/egos/weapon.lua')

newEntity {
  power_source = {technique = true},
  name = 'long ', prefix = true, instant_resolve = true,
  keywords = {long = true},
  combat = {thrust_range = 1},
  level_range = {1, 50},
  rarity = 3,
  cost = 20,}
