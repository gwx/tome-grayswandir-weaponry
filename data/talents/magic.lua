newTalent {
  short_name = 'GRAYSWANDIR_MAGIC_WEAPONS_MASTERY',
  name = 'Magic Weapons Mastery',
  type = {'technique/combat-training', 1},
  require = {stat = {mag = function(level) return 12 + level * 6 end,},},
  mode = 'passive',
  hide = true,
	getDamage = function(self, t) return 10 * t.getWeaponPower(self, t, 'default') end,
	getPercentInc = function(self, t) return math.sqrt(t.getWeaponPower(self, t) / 5) / 2 end,
  getWeaponPower = function(self, t) return self:getTalentLevel(t) * t.getFactor(self, t) end,
  getFactor = function(self, t) return 0.8 end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		return ([[Increases Physical Power by %d, and increases weapon damage by %d%% when using magical weapons.]]):
		format(damage, 100*inc)
	end,}
