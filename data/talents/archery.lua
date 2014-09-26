local t


-- SHOOT
Talents.talents_def.T_SHOOT.on_pre_use = function(self, t, silent)
  if #self:getArcheryWeapons() == 0 then
    if not silent then
      game.logPlayer(self, 'You have nothing that you can shoot.')
    end
    return false
  end
  return true
end


-- RELOAD
t = Talents.talents_def.T_RELOAD
local reload_on_pre_use = t.on_pre_use
t.on_pre_use = function(self, t, sient)
  local ammo = self:needReload()
  if not ammo then return false end
  return true
end
local reload_info = t.info
t.info = function(self, t)
  local ammo = self:needReload()
  if ammo then
    return ([[Reloads your %s (%d/%d) by %d.
(Reloading does not break stealth.)]])
      :format(ammo.name, ammo.combat.shots_left, ammo.combat.capacity, self:reloadRate(ammo))
  else
    return [[Reloads ammo. You currently have no ammo missing.
(Reloading does not break stealth.)]]
  end
end

-- Masteries
local masteries = {
  BOW_MASTERY = {name = 'bow', type = 'bow', reload = 0.5, info = 'full'},
  SLING_MASTERY = {name = 'sling', type = 'sling', reload = 0.5, info = 'full'},
	SKIRMISHER_SLING_SUPREMACY = {name = 'sling', type = 'sling', reload = 0.5, info = 'full'},
  KNIFE_MASTERY = {name = 'dagger', type = 'knife', reload = 0.35, info = 'reload'},}
for mastery, params in pairs(masteries) do
  t = Talents.talents_def['T_'..mastery]
  t.ammo_mastery_reload = function(self, t)
    return math.floor(self:getTalentLevel(t) * params.reload)
  end
  t.passives = function(self, t, p)
    self:talentTemporaryValue(
      p, 'ammo_mastery_reload', {[params.type] = t.ammo_mastery_reload(self, t)})
  end
  local old_info = t.info
  if params.info == 'full' then
    t.info = function(self, t)
      return ([[Increases Physical Power by %d and increases weapon damage by %d%% when using %ss.
Increases your reload rate with associated ammos by %d.]])
        :format(
          t.getDamage(self, t),
          t.getPercentInc(self, t) * 100,
          params.name,
          t.ammo_mastery_reload(self, t))
    end
  elseif params.info == 'reload' then
    t.info = function(self, t)
      local str = ('\nIncreases your reload rate with associated ammos by %d.')
        :format(t.ammo_mastery_reload(self, t))
      return old_info(self, t)..str
    end
  end
end
