newTalentType {
	type = 'technique/buckler-offense',
	name = 'Buckler Offense',
	description = 'Mostly hitting things with a buckler.'}

local make_require = function(tier)
	return function(self, t)
		local stat = self:getDex() >= self:getCun() and 'dex' or 'cun'
		return {
			stat = {[stat] = function(level) return 2 + tier * 8 + level * 2 end,},
			level = function(level) return -5 + tier * 4 + level end,}
	end
end

local on_pre_use = function(self, t, silent)
	if not self:getBuckler() then
		if not silent then
			game.logPlayer(self, 'This talent requires a buckler.')
		end
		return false
	end
	return true
end

newTalent {
	name = 'Lightning Bash',
	type = {'technique/buckler-offense', 1},
	require = make_require(1),
	points = 5,
	no_energy = true,
	stamina = 6,
	cooldown = function(self, t)
		return math.floor(12 - self:combatTalentLimit(t, 8, 0, 6))
	end,
	requires_target = true,
	range = 1,
	tactical = {ATTACK = 2,},
	on_pre_use = on_pre_use,
	damage = function(self, t) return self:combatTalentWeaponDamage(t, 1.1, 1.7) end,
	action = function(self, t)
		local buckler = self:getBuckler()
		if not buckler or not buckler.special_combat then
			game.logPlayer(self, 'This talent requires a buckler.')
			return
		end

		local range = self:getTalentRange(t)
		local tg = {type = 'hit', range = range,}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return end
		if core.fov.distance(self.x, self.y, x, y) > range then return end

		self:attackTargetWith(
			target, buckler.special_combat, nil, t.damage(self, t))
		return true
	end,
	info = function(self, t)
		return ([[Instantly bash the target with your buckler for %d%% damage.
Every time an enemy misses you in melee, this talent cools down by 1.]])
			:format(t.damage(self, t) * 100)
	end,}

newTalent {
	name = 'Disorienting Bash',
	type = {'technique/buckler-offense', 2},
	require = make_require(2),
	points = 5,
	cooldown = 4,
	stamina = 6,
	requires_target = true,
	range = 1,
	tactical = {ATTACK = 1, DISABLE = 2,},
	damage = function(self, t) return self:combatTalentWeaponDamage(t, 1.1, 1.7) end,
	save_penalty = function(self, t)
		return self:combatTalentScale(t, 0.2, 0.4) * self:combatAttack()
	end,
	crit_bonus = function(self, t)
		return 10 + self:combatTalentScale(t, 0, 100) * self:getCun(0.4, true)
	end,
	on_pre_use = on_pre_use,
	action = function(self, t)
		local buckler = self:getBuckler()
		if not buckler or not buckler.special_combat then
			game.logPlayer(self, 'This talent requires a buckler.')
			return
		end

		local range = self:getTalentRange(t)
		local tg = {type = 'hit', range = range,}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return end
		if core.fov.distance(self.x, self.y, x, y) > range then return end

		local _, hit = self:attackTargetWith(
			target, buckler.special_combat, nil, t.damage(self, t))

		if hit then
			target:setEffect('EFF_GRAYSWANDIR_DISORIENTED', 1, {
												 save = t.save_penalty(self, t),
												 crit = t.crit_bonus(self, t),})
			target:crossTierEffect('EFF_OFFBALANCE', self:combatAttack(buckler.special_combat))
		end
		return true
	end,
	info = function(self, t)
		return ('Bash the target with your buckler for %d%% damage. If it hits, this will disorient them for one turn (no save), decreasing defense and physical save by %d (scaling with Accuracy) and increasing crit chance for attacks made against them by %d%% (scaling with Cunning).')
			:format(t.damage(self, t) * 100,
							t.save_penalty(self, t),
							t.crit_bonus(self, t))
	end,
	do_generic_option = function(t)
		if config.settings.tome.grayswandir_weaponry_generic_masteries ~= false then
			Talents.changeTalentType(t, {'technique/buckler-offense', 2,}, 2)
		else
			Talents.changeTalentType(t, {'technique/other', 2,})
		end
	end,}

newTalent {
	name = 'Combo Lunge',
	type = {'technique/buckler-offense', 3,},
	require = make_require(3),
	points = 5,
	cooldown = 14,
	stamina = 12,
	requires_target = true,
	range = 1,
	tactical = {ATTACK = 2, DISABLE = 2,},
	buckler_damage = function(self, t) return self:combatTalentWeaponDamage(t, 1.3, 2.1) end,
	weapon_damage = function(self, t) return self:combatTalentWeaponDamage(t, 1.0, 1.9) end,
	cripple_speed = function(self, t)
		return math.min(0.1 + self:getCun(0.25, true) + self:combatTalentLimit(t, 0.3, 0, 0.225),
										0.5)
	end,
	cripple_duration = function(self, t) return self:combatTalentLimit(t, 10, 3, 7) end,
	on_pre_use = on_pre_use,
	action = function(self, t)
		local buckler = self:getBuckler()
		if not buckler or not buckler.special_combat then
			game.logPlayer(self, 'This talent requires a buckler.')
			return
		end

		local range = self:getTalentRange(t)
		local tg = {type = 'hit', range = range,}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return end
		if core.fov.distance(self.x, self.y, x, y) > range then return end

		local _, hit = self:attackTargetWith(
			target, buckler.special_combat, nil, t.buckler_damage(self, t))

		if hit then
			local ox, oy = target.x, target.y
			if target:canBe('knockback') then
				target:knockback(self.x, self.y, 1)
				if self:canMove(ox, oy) then self:move(ox, oy, true) end
			else
				game.logSeen(target, '%s resists being knocked back!', target.name:capitalize())
			end
		end

		_, hit = self:attackTargetWith(
			target, nil, nil, t.weapon_damage(self, t))

		if hit then
			target:setEffect('EFF_CRIPPLE', t.cripple_duration(self, t), {
												 speed = t.cripple_speed(self, t),
												 apply_power = self:combatAttack()})
		end
		return true
	end,
	info = function(self, t)
		return ('Bash the target with your buckler for %d%% damage. If this hits, you knock them back 1 space and step into the space they were standing in. Then you follow up with a weapon strike for %d%% damage which attempts to cripple them (Acc vs. Phys Save), reducing attack speeds by %d%% (scaling with Cunning) for %d turns.')
			:format(t.buckler_damage(self, t) * 100,
							t.weapon_damage(self, t) * 100,
							t.cripple_speed(self, t) * 100,
							t.cripple_duration(self, t))
	end,}

newTalent {
	name = 'Buckler Focus',
	type = {'technique/buckler-offense', 4},
	require = make_require(4),
	points = 5,
	mode = 'passive',
	damage = function(self, t)
		return 0.1 + self:getDex(0.4, true) + self:combatTalentLimit(t, 0.7, 0, 0.5)
	end,
	info = function(self, t)
		return ('Whenever you hit with a buckler bash, follow up with a normal attack for %d%% damage (scaling with Dexterity).')
			:format(t.damage(self, t) * 100)
	end,}

Talents.talents_def.T_DISORIENTING_BASH:do_generic_option()
