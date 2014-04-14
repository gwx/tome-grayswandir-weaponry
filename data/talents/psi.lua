-- Telekinetic Grasp
-- Allow bows/slings to be equipped.
local t = Talents.talents_def.T_TELEKINETIC_GRASP
local telekinetic_graps_action = t.action
t.action = function(self, t)
  local old_psi_combat = self.use_psi_combat
  self.use_psi_combat = true

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

  local result = coroutine.yield()
  self.use_psi_combat = old_psi_combat
  if not result then return nil end
  return true
end
