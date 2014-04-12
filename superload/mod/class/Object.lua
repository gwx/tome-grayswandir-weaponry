local _M = loadPrevious(...)

function _M:descAccuracyBonus(desc, weapon, use_actor)
	use_actor = use_actor or game.player

	local showpct = function(v, mult)
		return ('+%0.1f%%'):format(v * mult)
	end

	local m = weapon.accuracy_effect_scale or 1
  local strength

  strength = use_actor:getAccuracyEffectStrength(weapon, 'sword')
	if strength then
		desc:add("Accuracy bonus: ", {"color","LIGHT_GREEN"}, showpct(0.4, m * strength), {"color","LAST"}, " crit.pwr / acc", true)
  end
  strength = use_actor:getAccuracyEffectStrength(weapon, 'axe')
	if strength then
		desc:add("Accuracy bonus: ", {"color","LIGHT_GREEN"}, showpct(0.2, m * strength), {"color","LAST"}, " crit / acc", true)
  end
  strength = use_actor:getAccuracyEffectStrength(weapon, 'mace')
	if strength then
		desc:add("Accuracy bonus: ", {"color","LIGHT_GREEN"}, showpct(0.1, m * strength), {"color","LAST"}, " dam / acc", true)
  end
  strength = use_actor:getAccuracyEffectStrength(weapon, 'staff')
	if strength then
		desc:add("Accuracy bonus: ", {"color","LIGHT_GREEN"}, showpct(4, m * strength), {"color","LAST"}, " procs dam / acc", true)
  end
  strength = use_actor:getAccuracyEffectStrength(weapon, 'knife')
	if strength then
		desc:add("Accuracy bonus: ", {"color","LIGHT_GREEN"}, showpct(0.5, m * strength), {"color","LAST"}, " APR / acc", true)
  end
  strength = use_actor:getAccuracyEffectStrength(weapon, 'whip')
  if strength then
    desc:add('Accuracy bonus: ', {'color','LIGHT_GREEN'}, showpct(0.5, m * strength), {'color','LAST'},
             ' turn loss / acc', true)
  end
  strength = use_actor:getAccuracyEffectStrength(weapon, 'rapid')
  if strength then
    desc:add('Accuracy bonus: ', {'color','LIGHT_GREEN'}, showpct(0.5, m * strength), {'color','LAST'},
             ' turn gain (self) / acc', true)
  end
  strength = use_actor:getAccuracyEffectStrength(weapon, 'blind')
  if strength then
    desc:add('Accuracy bonus: ', {'color','LIGHT_GREEN'}, showpct(1, m * strength), {'color','LAST'},
             ' blind chance / acc', true)
  end
  strength = use_actor:getAccuracyEffectStrength(weapon, 'swordbreaker')
  if strength then
    desc:add('Accuracy bonus: ', {'color','LIGHT_GREEN'}, showpct(1, m * strength), {'color','LAST'},
             ' disarm chance / acc', true)
  end
  strength = use_actor:getAccuracyEffectStrength(weapon, 'pull')
  if strength then
    desc:add('Accuracy bonus: ', {'color','LIGHT_GREEN'}, showpct(1, m * strength), {'color','LAST'},
             ' pull chance / acc', true)
  end
  strength = use_actor:getAccuracyEffectStrength(weapon, 'duel')
  if strength then
    local duel = {}
    if _G.type(strength) == 'table' then
      duel = strength
      strength = strength.power
    end
    desc:add('Accuracy bonus: ', {'color','LIGHT_GREEN'}, showpct(1, m * strength), {'color','LAST'},
             ' def buff chance / acc ', {'color','SLATE'},
             ('(%d def %d max %d dur)')
               :format(duel.def or 3, duel.max or 20, duel.dur or 3),
             {'color','LAST'}, true)
  end
  strength = use_actor:getAccuracyEffectStrength(weapon, 'duel_disrupt')
  if strength then
    local duel = {}
    if _G.type(strength) == 'table' then
      duel = strength
      strength = strength.power
    end
    desc:add('Accuracy bonus: ', {'color','LIGHT_GREEN'}, showpct(1, m * strength), {'color','LAST'},
             ' acc reduction chance / acc ', {'color','SLATE'},
             ('(%d acc %d max %d dur)')
               :format(duel.atk or 3, duel.max or 20, duel.dur or 3),
             {'color','LAST'}, true)
  end
  strength = use_actor:getAccuracyEffectStrength(weapon, 'silence')
  if strength then
    local params = {}
    if _G.type(strength) == 'table' then
      params = strength
      strength = strength.power
    end
    desc:add('Accuracy bonus: ', {'color','LIGHT_GREEN'}, showpct(1, m * strength), {'color','LAST'},
             ' silence chance / acc ', {'color','SLATE'},
             ('(%d dur)')
               :format(params.dur or 2),
             {'color','LAST'}, true)
  end
end

local getRequirementDesc = _M.getRequirementDesc
function _M:getRequirementDesc(who)
  local old_req = rawget(self, 'require')
  if not old_req then return end

  local _, req_index = who:canWearObject(self)
  -- Satisfies normal require, or we don't have any alts.
  if req_index == 0 or not self.alt_requires then
    return getRequirementDesc(self, who)
  end
  -- Satisfies alternate require
  if req_index then
    local old_req = rawget(self, 'require')
    self.require = self.alt_requires[req_index]
    local result = {getRequirementDesc(self, who)}
    self.require = old_req
    return unpack(result)
  end
  -- Doesn't satisfy any require, display them all.
  local str = getRequirementDesc(self, who)
  for i, alt_req in pairs(self.alt_requires) do
    self.require = alt_req
    local alt_str = getRequirementDesc(self, who)
    table.remove(str, #str)
    alt_str[1] = 'Alternately '..alt_str[1]
    str:merge(alt_str)
  end
  self.require = old_req
  return str
end

return _M
