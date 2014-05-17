newTalent {
	short_name = 'GRAYSWANDIR_BUCKLER_MASTERY',
	name = 'Buckler Mastery',
	type = {'technique/combat-training', 1,},
	require = {
			stat = {dex = function(level) return 14 + level * 6 end,},},
	mode = 'passive',
	points = 5,
	duration = function(self, t)
		return math.ceil(self:combatTalentScale(t, 0.15,  1.15))
	end,
	count = function(self, t)
		return math.ceil(self:combatTalentScale(t, 0.30, 2.30))
	end,
	crit = function(self, t)
		return self:combatTalentIntervalDamage(t, 'str', 10, 50)
	end,
	info = function(self, t)
		local duration = t.duration(self, t)
		return ([[Improves your counterattacking ability when using bucklers:
The vulnerability debuff lasts %d more turn%s.
The number of attacks that vulnerability lasts for is increased by %d.
Increases the crit chance of counterattacks by %d%% (scaling with Strength).]])
			:format(
				duration, duration > 1 and 's' or '',
				t.count(self, t),
				t.crit(self, t))
	end,}

newTalent {
	short_name = 'GRAYSWANDIR_GUARD',
	name = 'Guard',
	image = 'talents/block.png',
	type = {'technique/objects', 1},
	cooldown = function(self, t)
		return 8 - util.bound(self:getTalentLevelRaw(t), 1, 5)
	end,
	points = 5,
	hard_cap = 5,
	range = 0,
	requires_target = false,
	tactical = {ATTACK = 3, DEFEND = 3,},
	on_pre_use = function(self, t, silent)
		if not self:getBuckler() then
			if not silent then
				game.logPlayer(self, 'You must be wearing a buckler to use this talent.')
			end
			return false
		end
		return true
	end,
	getCriticalChanceReduction = function(self, t)
		return 6 * (self:getTalentLevel(t) + 5)
	end,
	action = function(self, t)
		local buckler = self:getBuckler()
		if not buckler then return end
		local dur = 1 + (self:knowTalent('T_ETERNAL_GUARD') and 1 or 0)
		local count = 2
		local crit_reduction = t.getCriticalChanceReduction(self, t)
		local vuln_dur = 2
		local vuln_crit = 0
		if self:knowTalent('T_GRAYSWANDIR_BUCKLER_MASTERY') then
			local mastery = self:getTalentFromId('T_GRAYSWANDIR_BUCKLER_MASTERY')
			count = count + mastery.count(self, t)
			vuln_dur = vuln_dur + mastery.duration(self, t)
			vuln_crit = vuln_crit + mastery.crit(self, t)
		end
		self:setEffect('EFF_GUARDING', dur, {
										 count = count,
										 crit_reduction = crit_reduction,
										 vuln_dur = vuln_dur,
										 vuln_crit = vuln_crit,})
		return true
	end,
	info = function(self, t)
		return ('Use your buckler to actively deflect incoming attacks. While active, you use your Accuracy instead of Defense if it is higher against melee attacks and gain %d%% critical chance reduction. If someone misses you in melee then you will be in a position to counterattack them - your attack speed is doubled against such foes.')
			:format(t.getCriticalChanceReduction(self, t))
	end,}

local eternal_guard = Talents:getTalentFromId('T_ETERNAL_GUARD')
local eternal_guard_info = eternal_guard.info
eternal_guard.info = function(self, t)
	return eternal_guard_info(self, t):gsub('block', 'block or guard')
end
