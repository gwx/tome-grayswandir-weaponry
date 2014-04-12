newEntity {
  power_source = {technique = true},
  name = 'long ', prefix = true, instant_resolve = true,
  keywords = {long = true},
  combat = {thrust_range = 1},
  level_range = {1, 50},
  rarity = 3,
  cost = 20,
  }

newEntity {
  power_source = {technique = true},
  name = 'hooked ', prefix = true, instant_resolve = true,
  keywords = {hook = true},
  level_range = {1, 50},
  rarity = 3,
  cost = 10,
  wielder = {
    combat_dam = resolvers.mbonus_material(7, 3),},
  combat = {
    apr = resolvers.mbonus_material(8, 3),
    melee_project = {
      [DamageType.GRAYSWANDIR_TRIP] = resolvers.mbonus_material(40, 20),},},
}
