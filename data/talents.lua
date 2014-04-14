-- Add thrust range to various melee talents.
local melee_talents = {
  'ATTACK',
  {'WINDBLADE', thrust = false},
--[[
  'DEATH_BLOW',
  'STUNNING_BLOW',
  'SUNDER_ARMOUR',
  'SUNDER_ARMS',
  'BLEEDING_EDGE',
  'HACK_N_BACK',
  'DUAL_STRIKE',
  'FLURRY',
  'DIRTY_FIGHTING',
  'CRIPPLE',
  'VENOMOUS_STRIKE',
  'SHADOW_LEASH',
  'DEADLY_STRIKES',
  'TELEKINETIC_SMASH',
--]]
}

for i, params in pairs(melee_talents) do
  if _G.type(params) ~= 'table' then
    params = {params, thrust = true}
  end
  local talent = Talents.talents_def['T_'..params[1]]
  if talent then
    -- Enable thrust range for this talent.
    if params.thrust then
      if talent.range == 1 or not talent.range then
        talent.range = function(self, t) return self:get_thrust_range(keys) end
        -- Don't let this talent do ranged hits with normal melee weapons.
        talent.__disallow_ranged_melee = true
      end
      if _G.type(talent.target) == 'table' and
        talent.target.type == 'hit' and
        talent.target.range == 1
      then
        talent.target = function(self, t)
          return {type = 'beam', range = self:get_thrust_range(keys)}
        end
      end
    -- Disable any thrusting for this talent.
    elseif params.thrust == false then
      talent.__thrust_disabled = true
    end
  end
end



-- Modify Dual Weapon Defense to work with swordbreakers.
local dwd = Talents.talents_def.T_DUAL_WEAPON_DEFENSE
dwd.getDamageChange = function(self, t, fake)
  local dam,_,weapon = 0,self:hasDualWeapon()
  if not weapon or weapon.subtype=="mindstar" and not fake then return 0 end
  if weapon then
    local combat = weapon.combat
    if combat.dual_deflect then
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

-- Do the archery stuff.
load '/data-grayswandir-weaponry/talents/archery.lua'
load '/data-grayswandir-weaponry/talents/psi.lua'
