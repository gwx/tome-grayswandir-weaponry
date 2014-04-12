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
  return config.settings.tome.grayswandir_weaponry_alt_reload ~= false
    and 10 or 0
end
t.no_energy = function(self, t)
  return config.settings.tome.grayswandir_weaponry_alt_reload ~= false
end
local reload_on_pre_use = t.on_pre_use
t.on_pre_use = function(self, t, sient)
  if config.settings.tome.grayswandir_weaponry_alt_reload == false then
    return reload_on_pre_use(self, t, silent)
  end
  local ammo = self:needReload()
  if not ammo then return false end
  return true
end
local reload_info = t.info
t.info = function(self, t)
  if config.settings.tome.grayswandir_weaponry_alt_reload == false then
    return reload_info(self, t)
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
  if config.settings.tome.grayswandir_weaponry_alt_reload == false then
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
      if config.settings.tome.grayswandir_weaponry_alt_reload == false then
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



-- Telekinetic Grasp
-- Allow bows/slings to be equipped.
t = Talents.talents_def.T_TELEKINETIC_GRASP
local telekinetic_graps_action = t.action
t.action = function(self, t)
  local inven = self:getInven("INVEN")
  local d
  local filter = function(o)
    return o.type == "weapon" or o.type == "gem"
  end
  local action = function(o, item)
    local pf = self:getInven("PSIONIC_FOCUS")
    if not pf then return end
    -- Put back the old one in inventory
    local old = self:removeObject(pf, 1, true)
    if old then
      self:addObject(inven, old)
    end

    -- Fix the slot_forbid bug
    if o.slot_forbid then
      -- Store any original on_takeoff function
      if o.on_takeoff then
        o._old_on_takeoff = o.on_takeoff
      end
      -- Save the original slot_forbid
      o._slot_forbid = o.slot_forbid
      o.slot_forbid = nil
      -- And prepare the resoration of everything
      o.on_takeoff = function(self)
        -- Remove the slot forbid fix
        self.slot_forbid = self._slot_forbid
        self._slot_forbid = nil
        -- Run the original on_takeoff
        if self._old_on_takeoff then
          self.on_takeoff = self._old_on_takeoff
          self._old_on_takeoff = nil
          self:on_takeoff()
					-- Or remove on_takeoff entirely
        else
          self.on_takeoff = nil
        end
      end
    end

    o = self:removeObject(inven, item)
    -- Force "wield"
    self:addObject(pf, o)
    game.logSeen(self, "%s wears: %s.", self.name:capitalize(), o:getName{do_color=true})

    self:sortInven()
    d.used_talent = true
  end

  d = self:showInventory("Telekinetically grasp which item?", inven, filter, action)
  local co = coroutine.running()
  d.unload = function(self) coroutine.resume(co, self.used_talent) end
  if not coroutine.yield() then return nil end
  return true
end
