local g = require 'grayswandir.utils'
local get = util.getval

-- Allow to switch to generic shield mastery.
function Talents.talents_def.T_RIPOSTE:do_generic_option()
	if config.settings.tome.grayswandir_weaponry_generic_masteries ~= false then
		local index = g.hasv(
			Talents.talents_types_def['technique/combat-training'].talents,
			Talents:getTalentFromId('T_EXOTIC_WEAPONS_MASTERY'))
		Talents.changeTalentType(self, {'technique/combat-training', 1,}, index + 1)
		self.name = 'Shield Mastery'
		self.require = {
			stat = {str = function(level) return 14 + level * 6 end,},}
		Talents.changeTalentImage(self, 'talents/grayswandir_shield_mastery.png')
	else
		Talents.changeTalentType(self, {'technique/shield-offense', 2,}, 2)
		self.name = 'Riposte'
		self.require = {
			stat = {str = function(level) return 18 + level * 2 end,},
			level = function(level) return 3 + level end,}
		Talents.changeTalentImage(self, 'talents/riposte.png')
	end
end

newTalent{
	name = 'Counter Bash',
	short_name = 'GRAYSWANDIR_COUNTER_BASH',
	type = {'technique/other', 2},
	require = {
		stat = {str = function(level) return 14 + level * 6 end,},},
	points = 5,
	random_ego = 'attack',
	cooldown = 8,
	stamina = 18,
	tactical = { ATTACK = 2 },
	do_generic_option = function(t)
		if config.settings.tome.grayswandir_weaponry_generic_masteries ~= false then
			Talents.changeTalentType(t, {'technique/shield-offense', 2,}, 2)
		else
			Talents.changeTalentType(t, {'technique/other', 2,})
		end
	end,
	on_pre_use = function(self, t, silent)
		if not self:hasShield() then
			if not silent then
				game.logPlayer(self, "You require a weapon and a shield to use this talent.")
			end
			return false
		elseif #get(t.valid_targets, self, t) == 0 then
			if not silent then
				game.logPlayer(self, "You require an adjacent actor with the counterstrike debuff to use this talent.")
			end
			return false
		end
		return true
	end,
	range = 0,
	radius = 1,
	target = function(self, t)
		return {type = 'ball',
						range = self:getTalentRange(t),
						selffire = false,
						radius = self:getTalentRadius(t),}
	end,
	valid_targets = function(self, t)
		local tg = self:getTalentTarget(t)
		local targets = {}
		self:project(tg, self.x, self.y, function(px, py, tg, self)
			local target = game.level.map(px, py, Map.ACTOR)
			if target and
				target:hasEffect('EFF_COUNTERSTRIKE') and
				self:reactionToward(target) < 0
			then
				table.insert(targets, target)
			end
		end)
		return targets
	end,
	damage_multiplier = function(self, t)
		return self:combatTalentWeaponDamage(t, 1.2, 2.5, self:getTalentLevel('T_SHIELD_EXPERTISE'))
	end,
	action = function(self, t)
		local shield = self:hasShield()
		if not shield then
			game.logPlayer(self, 'You cannot use Revanche without a shield!')
			return
		end

		local tg = self:getTalentTarget(t)
		local targets = {}
		self:project(tg, self.x, self.y, function(px, py, tg, self)
			local target = game.level.map(px, py, Map.ACTOR)
			if target and
				target:hasEffect('EFF_COUNTERSTRIKE') and
				self:reactionToward(target) < 0
			then
				table.insert(targets, target)
			end
		end)

		if #targets == 0 then
			game.logPlayer(self, 'There are no valid targets nearby!')
			return
		end

		local mult = t.damage_multiplier(self, t)
		for _, target in pairs(targets) do
			self:attackTargetWith(target, shield.special_combat, nil, mult)
		end

		self:addParticles(Particles.new("meleestorm2", 1, {radius=2}))
		return true
	end,
	info = function(self, t)
		return ([[Shield bash every adjacent foe that is counterstriked for %d%% damage.]])
			:format(t.damage_multiplier(self, t) * 100)
	end,
}

-- Do initial switch if necessary.
if config.settings.tome.grayswandir_weaponry_generic_masteries ~= false then
	Talents.talents_def.T_RIPOSTE:do_generic_option()
	Talents.talents_def.T_GRAYSWANDIR_COUNTER_BASH:do_generic_option()
end
