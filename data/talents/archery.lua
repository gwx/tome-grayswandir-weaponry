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
t.stamina = function(self, t)
  return config.settings.tome.grayswandir_weaponry_alt_reload ~= 'normal'
    and 10 or 0
end
t.no_energy = (config.settings.tome.grayswandir_weaponry_alt_reload == 'alternate')
local reload_on_pre_use = t.on_pre_use
t.on_pre_use = function(self, t, sient)
	local conf = config.settings.tome.grayswandir_weaponry_alt_reload
  if conf == 'normal' then
    return reload_on_pre_use(self, t, silent)
	elseif conf == 'none' then
		return false
  end

  if config.settings.tome.grayswandir_weaponry_alt_reload == false then
  end
  local ammo = self:needReload()
  if not ammo then return false end
  return true
end
local reload_info = t.info
t.info = function(self, t)
	local conf = config.settings.tome.grayswandir_weaponry_alt_reload
  if conf == 'normal' then
    return reload_info(self, t)
	elseif conf == 'none' then
		return 'You have reload disabled.'
  end

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

local reload_action = t.action
t.action = function(self, t)
  if config.settings.tome.grayswandir_weaponry_alt_reload == 'normal' then
    return reload_action(self, t)
  end

  if self.resting then return end
  if not self.reload then return end
  return self:reload()
end


-- Masteries
local masteries = {
  bow = {reload = 0.5, info = 'full'},
  sling = {reload = 0.5, info = 'full'},
  knife = {reload = 0.35, info = 'reload'},}
for mastery, params in pairs(masteries) do
  t = Talents.talents_def['T_'..mastery:upper()..'_MASTERY']
  t.ammo_mastery_reload = function(self, t)
    return math.floor(self:getTalentLevel(t) * params.reload)
  end
  t.passives = function(self, t, p)
    self:talentTemporaryValue(
      p, 'ammo_mastery_reload', {[mastery] = t.ammo_mastery_reload(self, t)})
  end
  local old_info = t.info
  if params.info == 'full' then
    t.info = function(self, t)
      if config.settings.tome.grayswandir_weaponry_alt_reload == 'normal' then
        return old_info(self, t)
      end
      return ([[Increases Physical Power by %d and increases weapon damage by %d%% when using %ss.
Increases your reload rate with associated ammos by %d.]])
        :format(
          t.getDamage(self, t),
          t.getPercentInc(self, t) * 100,
          mastery,
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
