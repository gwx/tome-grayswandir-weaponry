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
