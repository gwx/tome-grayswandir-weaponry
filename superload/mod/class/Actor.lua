local _M = loadPrevious(...)

local g = require 'grayswandir.utils'

_M.temporary_values_conf.combat_physspeed_multiplier = 'mult'

-- Drains a percent of a turn's energy, up to limit percent (default 100%).
function _M:drain_energy(percent, limit)
  percent = percent or 10
  limit = limit or 100
  local tp = self.turn_procs

  -- Make sure we don't go over 50% of a turn.
  local current_drain = tp.energy_drain or 0
  if current_drain >= limit then return end

  percent = math.min(limit - current_drain, percent)
  tp.energy_drain = current_drain + percent

  -- Drain the energy
  self.energy.value = self.energy.value - game.energy_to_act * percent * 0.01

  return true
end

-- Boosts a percent of a turn's energy, up to limit percent (default 50%).
function _M:boost_energy(percent, limit)
  percent = percent or 10
  limit = limit or 50
  local tp = self.turn_procs

  -- Make sure we don't go over 50% of a turn.
  local current_boost = tp.energy_boost or 0
  if current_boost >= limit then return end
  percent = math.min(limit - current_boost, percent)
  tp.energy_boost = current_boost + percent

  -- Drain the energy
  self.energy.value = self.energy.value + game.energy_to_act * percent * 0.01

  return true
end


-- Add an alt_requires to objects, any of which can be satisified to
-- wear them. Second return is the index of the require satisfied, 0
-- for main.
local canWearObject = _M.canWearObject
function _M:canWearObject(o, try_slot)
  -- Try the original require.
  if canWearObject(self, o, try_slot) then return true, 0 end

  -- Try alt requires if we have them.
  if not o.alt_requires then return false end
  local old_require = rawget(o, 'require')
  for i, req in pairs(o.alt_requires) do
    o.require = req
    if canWearObject(self, o, try_slot) then
      o.require = old_require
      return true, i
    end
  end
  o.require = old_require
  return false
end

-- Allow us to see if we're in the postUseTalent section.
local postUseTalent = _M.postUseTalent
function _M:postUseTalent(ab, ret, silent)

	-- Do vulnerable checks.
	local vulnerable_bonus
	if not util.getval(ab.no_energy, self, ab) then
		-- First check if we only hit vulnerable targets.
		local all_vulnerable = true
		for target, _ in pairs(self.turn_procs.melee_targets or {}) do
			local vulnerable = target.hasEffect and target:hasEffect('EFF_GUARD_VULNERABLE')
			if not g.get(vulnerable, 'src', self) then
				all_vulnerable = false
			end
		end
		-- If we have, then do all the vulnerable stuff.
		if all_vulnerable then
			for target, _ in pairs(self.turn_procs.melee_targets or {}) do
				-- Do the countdown.
				local vulnerable = target:hasEffect('EFF_GUARD_VULNERABLE')
				if vulnerable then
					vulnerable.count = vulnerable.count - 1
					if vulnerable.count <= 0 then
						target:removeEffect('EFF_GUARD_VULNERABLE')
					end
				end
			end
			-- Apply vulnerable bonus.
			vulnerable_bonus = self:addTemporaryValue('combat_physspeed_multiplier', 2)
		end
	end

  self.__talent_running_post = ab
  local ret = {postUseTalent(self, ab, ret, silent)}
  self.__talent_running_post = nil

	-- Get rid of vulnerable bonus.
	if vulnerable_bonus then
		self:removeTemporaryValue('combat_physspeed_multiplier', vulnerable_bonus)
	end

	-- Cancel out all the hits.
	self.turn_procs.melee_targets = {}

  return unpack(ret)
end

local waitTurn = _M.waitTurn
function _M:waitTurn()
	local reloadQS = self.reloadQS
	self.reloadQS = nil
	waitTurn(self)
	self.reloadQS = reloadQS
end

-- Allow pools to be learned for any attribute, not just talents.
-- talent is the pool to be learned, reason is the key to save as.
function _M:modifyPool(pool_id, reason, amount)
  if not amount then return end
  local pool = self.resource_pool_refs[pool_id]
  if not pool then
    pool = {}
    self.resource_pool_refs[pool_id] = pool
  end
  g.inc(pool, reason, amount)
  if next(pool) then
    if not self:knowTalent(pool_id) then
      self:learnTalent(pool_id, true)
    end
  else
    if self:knowTalent(pool_id) then
      self:unlearnTalent(pool_id)
    end
  end
end

-- Returns true if you have all the resources.
function _M:hasResources(resources)
  for resource, amount in pairs(resources) do
    local get = self['get'..resource:capitalize()]
    if get(self) < amount then return end
  end
  return true
end

-- Uses all the resources
function _M:useResources(resources)
  for resource, amount in pairs(resources) do
    self['inc'..resource:capitalize()](self, -amount)
  end
  return true
end

-- Makes a hidden talent visible.
function _M:revealTalent(talent_id)
  g.set(self, '__show_special_talents', talent_id, true)
end

function _M:isTalentRevealed(talent_id)
  return g.get(self, '__show_special_talents', talent_id)
end

local wearObject = _M.wearObject
function _M:wearObject(o, replace, vocal)

	local slots = {o:wornInven()}
	local offslot = self:getObjectOffslot(o)
	if offslot then table.insert(slots, offslot) end

	if #slots == 0 then
		if vocal then game.logSeen(self, '%s is not wearable.', o:getName{do_color = true,}) end
		return false
	end

	local do_replace = false
	for i = 1, replace and 2 or 1 do
		for _, slot in pairs(slots) do
			local inven = self:getInven(slot)
			if inven and (#inven < inven.max or replace) and
				self:canWearObject(o, inven.name) and
				not o:check('on_canwear', self, slot)
			then
				if self:addObject(inven, o) then
					if vocal then
						game.logSeen(self, '%s wears: %s.', self.name:capitalize(), o:getName{do_color=true})
					end
					return true
				elseif do_replace then
					local ro = self:removeObject(inven, 1, true)
					if vocal then
						game.logSeen(self, '%s wears(replacing): %s.', self.name:capitalize(), o:getName{do_color=true})
					end
					-- Can we stack the old and new one ?
					if o:stack(ro) then ro = true end
					-- Warning: assume there is now space
					self:addObject(inven, o)
					return ro
				end
			end
		end
		do_replace = true
	end

	if vocal then
		game.logSeen(self, '%s can not wear: %s.', self.name:capitalize(), o:getName{do_color=true})
	end
	return false
end

return _M
