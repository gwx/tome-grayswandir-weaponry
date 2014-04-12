if config.settings.tome.grayswandir_weaponry_rapiers ~= false then

  newEntity {
    base = 'BASE_RAPIER',
    name = 'Wooden Rapier', unided_name = 'elm rapier',
    power_source = {nature = true,},
    unique = true,
    color = colors.BROWN,
    desc = [[This is a rapier made completely out of wood. It does not appear to have been crafted, but grown into this shape.]],
    rarity = 200,
    cost = 150,
    material_level = 1,
    require = {stat = {str = 10, dex = 10, cun = 10,},},
    combat = {
      dam = 12,
      damtype = DamageType.NATURE,
      dammod = {str = 0.4, dex = 0.4, cun = 0.4},
      apr = 1,
      physcrit = 2,
      extra_accuracy_effects = {
        duel = {power = 1.5, def = 3, max = 30, dur = 4,},},},
    wielder = {
      inc_damage = {
        [DamageType.NATURE] = 12,},
      combat_atk = 12,
      healing_factor = 0.1,},}

  newEntity {
    base = 'BASE_RAPIER',
    name = 'Deft Blade',
    unided_name = 'steel rapier',
    power_source = {technique = true},
    unique = true,
    color = colors.SLATE,
    desc = [[This blade seems to be perfectly balanced. A skilled warrior could make great use of it.]],
    rarity = 250,
    cost = 250,
    material_level = 2,
    require = {stat = {cun = 16, dex = 16},},
    level_range = {4, 22},
    combat = {
      dam = 25,
      apr = 5,
      physcrit = 5,
      dammod = {str = 0.4, dex = 0.6, cun = 0.4},
      accuracy_effect = 'none',
      extra_accuracy_effects = {
        sword = 2, knife = 2, mace = 2, axe = 2, staff = 2,},},
    wielder = {
      resists_pen = {[DamageType.PHYSICAL] = 10},
      combat_atk = 8,
      combat_def = 8,
      inc_stats = {dex = 4},},
  }

end

if config.settings.tome.grayswandir_weaponry_swordbreakers ~= false then

  newEntity {
    base = 'BASE_SWORDBREAKER',
    define_as = 'SHADOW_DEFENDER',
    name = 'Shadow Defender', unique = true,
    unided_name = 'obsidian swordbreaker',
    desc = [[This swordbreaker has enchanted to call upon the wielder's own shadow to help protect it.]],
    level_range = {14, 29},
    power_source = {arcane = true},
    material_level = 3,
    combat = {
      dam = 10,
      apr = 5,
      physcrit = 10,
      extra_accuracy_effects = {
        swordbreaker = 1.5,}, -- bringing it up to 2.5% disarm per acc.
      melee_project = {
        [DamageType.GRAYSWANDIR_BLIND] = 30, -- % blind chance.
        [DamageType.DARKNESS] = 30,},},
    wielder = {
      talent_cd_reduction={
        T_SHADOW_LEASH = 8,},
      inc_damage = {
        [DamageType.DARKNESS] = 10,},},}

--[=[
  newEntity {
    base = 'BASE_SWORDBREAKER',
    name = 'Phasebreaker',
    unided_name = 'translucent swordbreaker',
    power_source = {arcane = true},
    unique = true,
    color = colors.PURPLE,
    desc = [[This is a translucent swordbreaker. When you swing it, it moves in strange ways.]],
    rarity = 300,
    cost = 400,
    material_level = 2,
    level_range = {8, 30},
    require = {stat = {dex = 16, mag = 10}},
    combat = {
      dam = 8,
      apr = 8,
      physcrit = 14,
      extra_accuracy_effects = {swordbreaker = 1,},
      dammod = {str = 0.4, dex = 0.4, mag = 0.2},
      convert_damage = {[DamageType.ARCANE] = 20},
      special_on_hit = {
        desc = 'gain a displacement shield (scales with spellpower).',
        fct = function(combat, who, target)
          if not target or target == self then return end
          local power = 20 + self:combatSpellpower()
          local chance = math.min(50, 25 + self:combatSpellpower() * 0.2),
          -- Cancel out early if there is an existing shield.
          if self:hasEffect('EFF_DISPLACEMENT_SHIELD') then retrun end
          self:setEffect('EFF_DISPLACEMENT_SHIELD', 6, {
                           power = power, chance = chance, target = target,})
          game:playSoundNear(self, 'talents/teleport')
      end},},
    wielder = {
      inc_stats = {mag = 2, dex = 2,},
      combat_spellpower = 6,},}
]=]--



end

if config.settings.tome.grayswandir_weaponry_spears ~= false then

  newEntity {
    base = 'BASE_SPEAR',
    name = 'Frozen Light',
    unided_name = 'glowing stick',
    power_source = {arcane = true},
    offslot = 'OFFHAND',
    unique = true,
    color = colors.YELLOW,
    desc = [[This appears to be a long beam of light, frozen in time. It is rapidly expanding and contracting, as if trying to escape.]],
    rarity = 250,
    cost = 400,
    encumber = 0,
    metallic = false,
    material_level = 1,
    level_range = {1, 14},
    require = {stat = {mag = 12}},
    combat = {
      thrust_color = {rmax = 240, gmax = 240, bmax = 60,},
      dam = 8,
      apr = 10,
      physcrit = 4,
      physspeed = 1,
      talented = 'knife',
      accuracy_effect = 'staff',
      extra_accuracy_effects = {blind = 1,},
      dammod = {str = 0.6, mag = 0.6},
      convert_damage = {[DamageType.LIGHT] = 50, [DamageType.TEMPORAL] = 50},
      thrust_range = 3},
    wielder = {
      inc_stats = {mag = 4},
      combat_spellpower = 6,
      inc_damage = {[DamageType.LIGHT] = 15, [DamageType.TEMPORAL] = 15},},}

  newEntity {
    base = 'BASE_GREATSPEAR',
    name = 'Frozen Lance', unided_name = 'giant icicle',
    power_source = {nature = true},
    unique = true,
    color = colors.BLUE,
    desc = [[You are unable to tell whether this lance is crafted from steel or ice.]],
    rarity = 187,
    cost = 300,
    level_range = {11, 21},
    require = {stat = {str = 22,},},
    combat = {
      dam = 30,
      apr = 10,
      physcrit = 2,
      dammod = {str = 1.2},
      thrust_color = {rmax = 40, gmax = 100, bmax = 255,},
      burst_on_hit = {[DamageType.ICE] = 20,},},
    wielder = {
      inc_damage = {[DamageType.COLD] = 15,},
      combat_armor = 8,},}

  newEntity {
    base = 'BASE_SHIELD',
    power_source = {psionic = true},
    unique = true,
    name = 'Indomitable', unided_name = 'massive mindstar',
    desc = [[This is a massive mindstar in the shape of a shield.]],
    rarity = 240,
    cost = 300,
    require = {stat = {str = 26, wil = 26},},
    material_level = 3,
    special_combat = {
      thrust_color = {rmax = 60, gmax = 240, bmax = 180,},
      extra_accuracy_effects = {knife = 2,},
      dam = 28,
      block = 110,
      physcrit = 4,
      dammod = {str = 0.6, wil = 0.6},
      thrust_range = 2,},
    wielder = {
      combat_def = 8,
      combat_def_ranged = 8,
      fatigue = 8,
      learn_talent = {T_BLOCK = 3,},
      combat_physresist = 8,
      combat_mentalresist = 16,
      resists = {[DamageType.MIND] = 30, [DamageType.NATURE] = 10,},},}

end
