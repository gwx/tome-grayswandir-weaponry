local hook = function(self, data)
  local player = game.player

  -- Display additional ammos.
  local quiver_ammo = player:getInven("QUIVER")
  quiver_ammo = quiver_ammo and quiver_ammo[1]

  for i, ammo in ipairs(player:getArcheryAmmos()) do
    if not ammo then goto skip_ammo end
    -- Don't display the quiver ammo, it's already being displayed.
    if ammo == quiver_ammo then goto skip_ammo end

    local amt, max = 0, 0
    local shad, bg
    if ammo.type == "alchemist-gem" then
      shad, bg = self["ammo_shadow_alchemist-gem"], self["ammo_alchemist-gem"]
      amt = ammo:getNumber()
    else
      shad = self["ammo_shadow_"..ammo.subtype] or self.ammo_shadow_default
      bg = self["ammo_"..ammo.subtype] or self.ammo_default
      amt, max = ammo.combat.shots_left, ammo.combat.capacity
    end

    shad[1]:toScreenFull(data.x, data.y, shad[6], shad[7], shad[2], shad[3], 1, 1, 1, data.a)
    bg[1]:toScreenFull(data.x, data.y, bg[6], bg[7], bg[2], bg[3], 1, 1, 1, data.a)

    self.res.ammos = self.res.ammos or {}
    if not self.res.ammos[ammo] or
      self.res.ammos[ammo].vc ~= amt or
      self.res.ammos[ammo].vm ~= max
    then
      self.res.ammos[ammo] = {
        vc = amt, vm = max,
        cur = {core.display.drawStringBlendedNewSurface(self.font_sha, max > 0 and ("%d/%d"):format(amt, max) or ("%d"):format(amt), 255, 255, 255):glTexture()},
      }
    end

    local dt = self.res.ammos[ammo].cur
    dt[1]:toScreenFull(2+data.x+44, 2+data.y+3 + (bg[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 0, 0, 0, 0.7 * data.a)
    dt[1]:toScreenFull(data.x+44, data.y+3 + (bg[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 1, 1, 1, data.a)
    data.x, data.y = self:resourceOrientStep(
      data.orient, data.bx, data.by, data.scale, data.x, data.y, self.fshat[6], self.fshat[7])

    ::skip_ammo::
  end
  return true
end
class:bindHook('UISet:Minimalist:Resources', hook)
