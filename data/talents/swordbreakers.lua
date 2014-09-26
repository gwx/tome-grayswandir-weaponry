-- Modify Dual Weapon Defense to work with swordbreakers.
local dwd = Talents.talents_def.T_DUAL_WEAPON_DEFENSE
dwd.getDamageChange = function(self, t, fake)
  local dam,_,weapon = 0,self:hasDualWeapon()
  if not weapon or weapon.subtype=="mindstar" and not fake then return 0 end
  if weapon then
    local combat = weapon.combat
    if combat and combat.dual_deflect then
      -- Setup the table once to point to the combat table.
      if not combat.dual_deflect.__setup then
        combat.dual_deflect.__setup = true
        setmetatable(combat.dual_deflect, combat.dual_deflect)
        local index = combat
        combat.dual_deflect.__index = function(table, key)
          return index[key]
        end
      end
      combat = combat.dual_deflect
    end
    dam = self:combatDamage(combat) * self:getOffHandMult(combat)
  end
  return t.getDeflectPercent(self, t) * dam/100
end
local base_chance = dwd.getDeflectChance
dwd.getDeflectChance = function(self, t)
  local add, _, weapon = 0, self:hasDualWeapon()
  if weapon and weapon.combat and weapon.combat.dual_deflect then
    add = add + weapon.combat.dual_deflect.chance
  end
  return base_chance(self, t) + add
end
