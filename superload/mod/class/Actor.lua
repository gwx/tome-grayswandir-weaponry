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
  self.__talent_running_post = ab
  local ret = {postUseTalent(self, ab, ret, silent)}
  self.__talent_running_post = nil
  return unpack(ret)
end

-- Add reloading to energy use.
local useEnergy = _M.useEnergy
function _M:useEnergy(val)
  useEnergy(self, val)
  if not self.__talent_running and
    not self.__talent_running_post
  then
		local conf = config.settings.tome.grayswandir_weaponry_alt_reload
    if conf == 'alternate' then
      if self.reload then self:reload() end
    end
  end
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

return _M
