load('/data-grayswandir-weaponry/egos/1hweapons.lua')
load('/data-grayswandir-weaponry/egos/all-axes.lua')
load('/data/general/objects/egos/weapon.lua')

newEntity {
  power_source = {nature = true},
  name = 'woodsman\'s ', prefix = true, instant_resolve = true,
  keywords = {woodsman = true},
  level_range = {1, 50},
  rarity = 5,
  cost = 5,
  combat = {
    melee_project = {
      [DamageType.NATURE] = resolvers.mbonus_material(15, 5),},
    inc_damage_type = {
      ['immovable/plants'] = resolvers.mbonus_material(25, 5)},},
  wielder = {
    resists = {
      [DamageType.NATURE] = resolvers.mbonus_material(5, 10),},},}
