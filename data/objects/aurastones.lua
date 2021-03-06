if config.settings.tome.grayswandir_weaponry_aurastones ~= false then

  newEntity{
    define_as = 'BASE_AURASTONE',
    slot = 'MAINHAND', offslot = 'OFFHAND',
    type = 'weapon', subtype='aurastone',
    display = '*', color=colors.WHITE,
		image = 'object/generic_aurastone.png',
    moddable_tile = '%s_aurastone',
    encumber = 1,
    rarity = 8,
    exotic = true,
    allow_unarmed = true,
    power_source = {arcane = true,},
    on_wear = function(self, who)
      -- Enable mana.
      who:modifyPool('T_MANA_POOL', 'aurastone', 1)

      -- Move resource strikes to be indexed by self. This is to get
      -- around them stacking.
      local strikes = self.wielder.combat.resource_strikes
      if not strikes[self.uid] then
        local index, strike = next(strikes)
        strikes[index] = nil
        strikes[self.uid] = strike
      end
    end,
    on_takeoff = function(self, who)
      -- Disable mana.
      who:modifyPool('T_MANA_POOL', 'aurastone', -1)

      -- Remove the resource strike field on who.
      who.combat.resource_strikes[self.uid] = nil
    end,
    desc = [[A small stone that exudes a faint magical aura. Those who are trained can channel magic through them while they are clenched in their fists, striking out with magical energies on every punch.]],
    --randart_able = '/data/general/objects/random-artifacts/melee.lua',
    addons = '/data-grayswandir-weaponry/addons/aurastones.lua',}

  newEntity{
    base = 'BASE_AURASTONE',
    name = 'dull aurastone', short_name = 'dull',
    level_range = {1, 10},
		image = 'object/aurastone_dull.png',
    require = {
      stat = {mag = 11,},
      talent = {{'T_GRAYSWANDIR_MAGIC_WEAPONS_MASTERY', 1,},},},
    cost = 8,
    material_level = 1,
    wielder = {
      combat = {
        resource_strikes = {
          {cost = {mana = 1,},
           talented = 'aurastone', accuracy_effect = 'staff',
           dam = 1,
					 physcrit = -50,
           dammod = {mag = 0.1,},},},},},}

  newEntity{
    base = 'BASE_AURASTONE',
    name = 'shiny aurastone', short_name = 'shiny',
    level_range = {10, 20},
		image = 'object/aurastone_shiny.png',
    require = {
      stat = {mag = 16,},
      talent = {{'T_GRAYSWANDIR_MAGIC_WEAPONS_MASTERY', 1,},},},
    cost = 14,
    material_level = 2,
    wielder = {
      combat = {
        resource_strikes = {
          {cost = {mana = 1.5,},
           talented = 'aurastone', accuracy_effect = 'staff',
           dam = 2,
					 physcrit = -45,
           dammod = {mag = 0.15,},},},},},}

  newEntity{
    base = 'BASE_AURASTONE',
    name = 'gleaming aurastone', short_name = 'gleaming',
    level_range = {20, 30},
		image = 'object/aurastone_gleaming.png',
    require = {
      stat = {mag = 25,},
      talent = {{'T_GRAYSWANDIR_MAGIC_WEAPONS_MASTERY', 2,},},},
    cost = 20,
    material_level = 3,
    wielder = {
      combat = {
        resource_strikes = {
          {cost = {mana = 2,},
           talented = 'aurastone', accuracy_effect = 'staff',
           dam = 3,
					 physcrit = -40,
           dammod = {mag = 0.2,},},},},},}

  newEntity{
    base = 'BASE_AURASTONE',
    name = 'glowing aurastone', short_name = 'glowing',
    level_range = {30, 40},
		image = 'object/aurastone_glowing.png',
    require = {
      stat = {mag = 34,},
      talent = {{'T_GRAYSWANDIR_MAGIC_WEAPONS_MASTERY', 2,},},},
    cost = 31,
    material_level = 4,
    wielder = {
      combat = {
        resource_strikes = {
          {cost = {mana = 2.5,},
           talented = 'aurastone', accuracy_effect = 'staff',
           dam = 4,
					 physcrit = -35,
           dammod = {mag = 0.25,},},},},},}

  newEntity{
    base = 'BASE_AURASTONE',
    name = 'brilliant aurastone', short_name = 'brilliant',
    level_range = {40, 50},
		image = 'object/aurastone_brilliant.png',
    require = {
      stat = {mag = 48,},
      talent = {{'T_GRAYSWANDIR_MAGIC_WEAPONS_MASTERY', 3,},},},
    cost = 43,
    material_level = 5,
    wielder = {
      combat = {
        resource_strikes = {
          {cost = {mana = 3,},
           talented = 'aurastone', accuracy_effect = 'staff',
           dam = 5,
					 physcrit = -30,
           dammod = {mag = 0.3,},},},},},}

end
