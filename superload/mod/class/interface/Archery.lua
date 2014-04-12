local _M = loadPrevious(...)
local g = require 'grayswandir'
local talents = require 'engine.interface.ActorTalents'

-- Get the current reload rate.
function _M:reloadRate(ammo)
  local kind = ammo.archery_ammo
  if config.settings.tome.grayswandir_weaponry_alt_reload == false and
    (kind == 'bow' or kind == 'sling' or not kind)
  then
    local t = talents.talents_def.T_RELOAD
    return t.shots_per_turn(self, t)
  end

  local mastery
  if not self.ammo_mastery_reload then
    mastery = 0
  elseif kind then
    mastery = self.ammo_mastery_reload[kind] or 0
  else
    mastery = table.max(self.ammo_mastery_reload) or 0
  end

  return 1 + mastery + (ammo.reload_speed or 0) + (self.weapon_reload_speed or 0)
end

-- Increase ammo by reload amount. Returns true if actually reloaded.
function _M:reloadAmmo(ammo)
  if not ammo.combat or
    not ammo.combat.capacity or
    not ammo.archery_ammo
  then return false end

  if ammo.combat.shots_left >= ammo.combat.capacity then return end
  local reloads = self:reloadRate(ammo)
  ammo.combat.shots_left = math.min(ammo.combat.capacity, ammo.combat.shots_left + reloads)
  return true
end

-- The order to reload slots in

_M.reload_order = {
  'QUIVER', 'MAINHAND', 'OFFHAND', 'PSIONIC_FOCUS',
  'QS_QUIVER', 'QS_MAINHAND', 'QS_OFFHAND', 'QS_PSIONIC_FOCUS',}

-- Return the first ammo that needs reloading.
function _M:needReload()
  for _, inven in ipairs(_M.reload_order) do
    inven = self:getInven(inven)
    local ammo = inven and inven[1]
    if ammo then
      local combat = ammo.combat
      if combat and combat.capacity and combat.shots_left and
        combat.shots_left < combat.capacity then
          return ammo
      end
    end
  end
  return false
end

-- Reload the first empty ammo on the reload list.
function _M:reload()
  for _, inven in ipairs(_M.reload_order) do
    inven = self:getInven(inven)
    if inven and inven[1] and self:reloadAmmo(inven[1]) then return true end
  end
  return false
end

return _M
