local rmm = resolvers.mbonus_material

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
    combat_dam = rmm(7, 3),},
  combat = {
    apr = rmm(8, 3),
    melee_project = {
      [DamageType.GRAYSWANDIR_TRIP] = rmm(40, 20),},},}

newEntity {
	power_source = {antimagic = true,},
	name = 'magic piercing ', prefix = ture, instant_resolve = true,
	level_range = {25, 50,},
	rarity = 22,
	cost = 34,
	greater_ego = 1,
	combat = {
		phasing = rmm(50, 10),
		melee_project = {
			[DamageType.MANABURN] = rmm(30, 10),},},
	wielder = {
		resist_pen = {
			[DamageType.ARCANE] = rmm(10, 5),},},}

newEntity {
	power_source = {arcane = true,},
	name = ' of lightning bolts', suffix = true, instant_resolve = true,
	level_range = {10, 50,},
	rarity = 19,
	cost = 28,
	greater_ego = 1,
	resolvers.charmt('T_LIGHTNING', {1, 2, 3,}, 14),
	combat = {
		convert_damage = {
			[DamageType.LIGHTNING] = rmm(25, 25),},
		burst_on_hit = {
			[DamageType.LIGHTNING] = rmm(15, 5),},},
	wielder = {
		resists_pen = {
			[DamageType.LIGHTNING] = rmm(15, 5),},
		inc_damage = {
			[DamageType.LIGHTNING] = rmm(15, 5),},},}

newEntity {
	power_source = {arcane = true,},
	name = ' of the heavens', suffix = true, instant_resolve = true,
	level_range = {20, 50,},
	rarity = 23,
	cost = 33,
	greater_ego = 1,
	combat = {
		convert_damage = {
			[DamageType.LIGHT] = rmm(25, 25),
			[DamageType.LIGHTNING] = rmm(25, 25),},
		burst_on_crit = {
			[DamageType.LIGHT] = rmm(15, 5),
			[DamageType.LIGHTNING] = rmm(15, 5),},},
	wielder = {
		resists_pen = {
			[DamageType.LIGHT] = rmm(15, 5),
			[DamageType.LIGHTNING] = rmm(15, 5),},
		inc_damage = {
			[DamageType.LIGHT] = rmm(15, 5),
			[DamageType.LIGHTNING] = rmm(15, 5),},},}
