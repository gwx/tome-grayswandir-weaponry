local get = util.getval

newTalent {
	name = 'Heavy Strike', short_name = 'GRAYSWANDIR_HEAVY_STRIKE',
	type = {'technique/objects', 1},
	points = 5,
	cooldown = 12,
	requires_target = true,
	range = 1,
	no_energy = 'fake',
	target = function(self, t) return {type = 'hit', range = get(t.range, self, t),} end,
	tactical = {ATTACK = 2,},
	weapon_mult = function(self, t) return self:scale {low = 1.2, high = 1.7, t,} end,
	knockback = function(self, t) return self:scale {low = 2.5, high = 6.5, t, after = 'ceil',} end,
	action = function(self, t)
		local tg = get(t.target, self, t)
		local x, y, actor = self:getTarget(tg)
		if not x or not y or not actor then return end
		if core.fov.distance(self.x, self.y, x, y) > tg.range then return end

		local hit = self:attackTarget(actor, nil, get(t.weapon_mult, self, t))
		if hit then
			if actor:canBe 'knockback' and
				actor:checkHit(self:combatPhysicalpower(), actor:combatPhysicalResist())
			then
				actor:knockback(self.x, self.y, get(t.knockback, self, t))
			else
				game.logSeen(actor, '%s resists being knocked back!', actor.name:capitalize())
			end
		end
		return true
	end,
	info = function(self, t)
		return ([[Perform a powerful strike on the target for %d%% weapon damage, attempting to knock them back %d spaces if it hits.]])
			:format(get(t.weapon_mult, self, t) * 100,
							get(t.knockback, self, t))
	end,}

newTalent {
	name = 'Throat Slitter', short_name = 'GRAYSWANDIR_THROAT_SLITTER',
	type = {'technique/objects', 1},
	points = 5,
	cooldown = 12,
	requires_target = true,
	range = 1,
	no_energy = 'fake',
	target = function(self, t) return {type = 'hit', range = get(t.range, self, t),} end,
	tactical = {ATTACK = 2,},
	weapon_mult = function(self, t) return self:scale {low = 1.1, high = 1.4, t,} end,
	crit_bonus = function(self, t) return self:scale {low = 10, high = 30, t,} end,
	silence = function(self, t) return self:scale {low = 2.5, high = 6.5, t, after = 'ceil',} end,
	action = function(self, t)
		local tg = get(t.target, self, t)
		local x, y, actor = self:getTarget(tg)
		if not x or not y or not actor then return end
		if core.fov.distance(self.x, self.y, x, y) > tg.range then return end

		self.turn_procs.is_any_crit = false
		local crit = self:addTemporaryValue('combat_physcrit', get(t.crit_bonus, self, t))
		local hit = self:attackTarget(actor, nil, get(t.weapon_mult, self, t))
		self:removeTemporaryValue('combat_physcrit', crit)

		if hit and self.turn_procs.is_any_crit then
			if rng.percent((actor.silence_immune or 0) * 50 + (actor.cut_immune or 0) * 50) and
				actor:checkHit(self:combatAttack(), actor:combatPhysicalResist())
			then
				actor:setEffect('EFF_GRAYSWANDIR_PHYSICAL_SILENCED', get(t.silence, self, t), {src = self,})
			else
				game.logSeen(actor, '%s resists being silenced!', actor.name:capitalize())
			end
		end
		return true
	end,
	info = function(self, t)
		return ([[Perform a powerful strike on the target for %d%% weapon damage, with an extra +%d%% critical chance. If you make a critical hit, it attempts to silence the target for %d turns, checking against the average of their bleed and silence immunity.]])
			:format(get(t.weapon_mult, self, t) * 100,
							get(t.crit_bonus, self, t),
							get(t.silence, self, t))
	end,}

newTalent {
	name = 'Sweeping Blows', short_name = 'GRAYSWANDIR_SWEEPING_BLOWS',
	type = {'technique/objects', 1},
	points = 5,
	cooldown = 6,
	no_energy = 'fake',
	mode = 'sustained',
	physspeed = function(self, t) return self:scale {low = 0.2, high = 0.1, limit = 0.5, t,} end,
	activate = function(self, t)
		local eff = {}
		local speed = (1 / (1 + get(t.physspeed, self, t))) - 1
		self:talentTemporaryValue(eff, 'combat_physspeed', speed)
		self:talentTemporaryValue(eff, 'combat_sweep_attack', 1)
		return eff
	end,
	deactivate = function(self, t, p) return true end,
	info = function(self, t)
		return ([[You attack with sweeping blows, hitting adjacent targets but making your attacks take %d%% longer.]])
			:format(get(t.physspeed, self, t) * 100)
	end,}
