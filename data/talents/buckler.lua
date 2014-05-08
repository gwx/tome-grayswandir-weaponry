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
		self:setEffect('EFF_GUARDING', dur, {
										 count = 2,
										 crit = t.getCriticalChanceReduction(self, t),})
		return true
	end,
	info = function(self, t)
		return ('Use your buckler to actively deflect incoming attacks. While active, you use your Accuracy instead of Defense if it is higher and gain %d%% critical chance reduction. If someone misses you in melee then you will be in a position to counterattack them - your attack speed is doubled as long as you do nothing but attack such foes.')
			:format(t.getCriticalChanceReduction(self, t))
	end,}

local eternal_guard = Talents:getTalentFromId('T_ETERNAL_GUARD')
local eternal_guard_info = eternal_guard.info
eternal_guard.info = function(self, t)
	return eternal_guard_info(self, t):gsub('block', 'block or guard')
end
