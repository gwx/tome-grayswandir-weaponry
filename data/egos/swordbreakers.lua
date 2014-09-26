load('/data/general/objects/egos/weapon.lua')

local stat = require 'engine.interface.ActorStats'

-- Make plain weapon egos rarer.
for i, ego in ipairs(loading_list) do
  if ego.rarity then ego.rarity = ego.rarity * 3 end
end

if config.settings.tome.grayswandir_weaponry_new_egos ~= false then

	newEntity{
		power_source = {technique=true},
		name = "balanced ", prefix=true, instant_resolve=true,
		keywords = {balanced=true},
		level_range = {1, 50},
		rarity = 5,
		cost = 15,
		wielder={
			combat_atk = resolvers.mbonus_material(10, 5),
			combat_def = resolvers.mbonus_material(10, 5),
		},
	}

	newEntity{
		power_source = {technique = true},
		name = "blocking ", prefix=true, instant_resolve=true,
		keywords = {blocking = true},
		level_range = {1, 50},
		rarity = 5,
		cost = 15,
		wielder = {
			combat_armor = resolvers.mbonus_material(7, 3),
			flat_damage_armor = {[DamageType.PHYSICAL] = resolvers.mbonus_material(7, 3),},},}


	newEntity {
		power_source = {technique = true},
		name = 'shiny ', prefix = true, instant_resolve = true,
		keywords = {shiny = true},
		level_range = {1, 50},
		rarity = 3,
		cost = 10,
		combat = {extra_accuracy_effects = {blind = 1,},},
		wielder = {
			lite = resolvers.mbonus_material(1, 1),
			combat_def = resolvers.mbonus_material(4, 2),},
	}

	newEntity {
		power_source = {technique = true},
		name = ' of retreat', suffix = true, instant_resolve = true,
		keywords = {retreat = true},
		level_range = {1, 50},
		rarity = 3,
		cost = 10,
		resolvers.charmt('T_HACK_N_BACK', {2,3,4}, 20),}

	-- I don't like this one. :(
	--[[
		newEntity {
		power_source = {technique = true},
		name = 'sundering ', prefix = true, instant_resolve = true,
		keywords = {sunder = true},
		level_range = {1, 50},
		rarity = 3,
		cost = 5,
		combat = {
    sunder_power = resolvers.mbonus_material(30, 15),
    sunder_duration = resolvers.mbonus_material(3, 4),
    special_on_crit = {
		desc = 'reduces target\'s accuracy',
		fct = function(combat, who, target)
		target:setEffect('EFF_SUNDER_ARMS', combat.sunder_duration, {
		apply_power = who:combatAttack(combat),
		power = combat.sunder_power})
    end},},
		wielder = {
    combat_atk = resolvers.mbonus_material(8, 2),}
		}
	]]--

	newEntity {
		power_source = {arcane = true},
		name = ' of shielding', suffix = true, instant_resolve = true,
		keywords = {shield = true},
		level_range = {1, 50},
		rarity = 3,
		cost = 15,
		combat = {
			physcrit = resolvers.mbonus_material(3, 3),
			shielding_base = resolvers.mbonus_material(30, 10),
			shielding_power = resolvers.mbonus_material(80, 30),
			special_on_crit = {
				desc = 'gain a damage shield (scaled with spellpower)',
				fct = function(combat, who, target)
					local power = combat.shielding_base + who:combatSpellpower() * combat.shielding_power * 0.01
					local shield = who:hasEffect('EFF_DAMAGE_SHIELD')
					if not shield or shield.power < power then
						who:setEffect('EFF_DAMAGE_SHIELD', 4, {power = power})
						game:playSoundNear(who, "talents/arcane")
					end
				end,},},
	}

	newEntity {
		power_source = {technique = true},
		name = 'dueling ', prefix = true, instant_resolve = true,
		keywords = {duel = true},
		level_range = {1, 50},
		rarity = 3,
		cost = 12,
		combat = {
			extra_accuracy_effects = {
				duel_disrupt = {
					power = 1,
					atk = resolvers.mbonus_material(4, 2),
					max = resolvers.mbonus_material(40, 20),
					dur = resolvers.mbonus_material(2, 2),},},},
		wielder = {
			inc_stats = {
				[stat.STAT_DEX] = resolvers.mbonus_material(3, 1),},},}

	newEntity {
		power_source = {psionic = true},
		name = ' of denial', suffix = true, instant_resolve = true,
		keywords = {denial = true},
		level_range = {1, 50},
		rarity = 4,
		cost = 20,
		combat = {dam = -2},
		wielder = {
			flat_damage_armor = {all = resolvers.mbonus_material(10, 2)},},
	}

	newEntity {
		power_source = {technique = true},
		name = ' of true breaking', suffix = true, instant_resolve = true,
		keywords = {['true']=true},
		level_range = {30,50},
		greater_ego = 1,
		rarity = 15,
		cost = 40,
		wielder = {
			combat_def = resolvers.mbonus_material(10, 3),
			combat_physcrit = resolvers.mbonus_material(8, 4),},
		combat = {
			swordbreaker_disarm_duration = resolvers.mbonus(5, 1),
			maim_power = resolvers.mbonus(30, 10),
			special_on_crit = {
				desc = 'maims the target',
				fct = function(combat, who, target)
					local duration = 2 + (combat.swordbreaker_disarm_duration or 0)
					target:setEffect('EFF_MAIMED', duration, {
														 src = who,
														 apply_power = who:combatAttack(weapon),
														 dam = combat.maim_power,})
				end,},},
	}

	newEntity {
		power_source = {nature = true},
		name = 'magnetized ', prefix = true, instant_resolve = true,
		keywords = {magnet = true},
		level_range = {30,50},
		greater_ego = 1,
		rarity = 15,
		cost = 40,
		wielder = {
			resists = {
				[DamageType.PHYSICAL] = resolvers.mbonus_material(10, 5),
				[DamageType.LIGHTNING] = resolvers.mbonus_material(20, 10),},
			combat_armor_hardiness = resolvers.mbonus_material(10, 5),
			combat_def = resolvers.mbonus(3, 0),
			combat_physresist = resolvers.mbonus(15, 5),},
	}

end
