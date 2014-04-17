local hook
local stats = require 'engine.interface.ActorStats'
local g = require 'grayswandir.utils'

-- Combat Tooltip
hook = function(self, data)
  if data.combat.sweep_attack then
		data.desc:add('Sweep Attack: This weapon hits nearby targets.\n')
	end
  if data.combat.thrust_range then
    data.desc:add(('Thrust Range: #LIGHT_GREEN#%d#LAST#\n'):format(data.combat.thrust_range + 1))
  end
  if data.combat.dual_deflect and game.player:knowTalent('T_DUAL_WEAPON_DEFENSE') then
    local d = data.combat.dual_deflect
    data.desc:add(('Dual Weapon Defense: #LIGHT_GREEN#%d#LAST# base power and #LIGHT_GREEN#+%d%%#LAST# parry chance.\n')
                    :format(d.dam, d.chance))
  end

  -- Replace Dammod line with our own.
  local index
  for i, value in ipairs(data.desc) do
    if _G.type(value) == 'string' and string.sub(value, 1, 9) == 'Uses stat' then

      -- Hook doesn't pass in the use_actor, so we're assuming it's the player.
      local use_actor = game.player

      -- Special check for psionic focus.
      local old_psi = use_actor.use_psi_combat
      for _, slot in pairs {'PSIONIC_FOCUS'} do
        slot = use_actor:getInven(slot)
        if slot and g.hasv(slot, self) then
          use_actor.use_psi_combat = true
          break
        end
      end

      -- Replace the line.
      local dm = {}
      local dammod = use_actor:getDammod(data.combat, true)
      for stat, i in pairs(dammod) do
        dm[#dm+1] = ('%d%% %s'):format(i * 100, stats.stats_def[stat].short_name:capitalize())
      end
      data.desc[i] = ('Uses stat%s: %s'):format(#dm > 1 and 's' or '',table.concat(dm, ', '))

      -- Turn back psi combat.
      use_actor.use_psi_combat = old_psi

      break
    end
  end

  -- Resource Strikes
  if data.combat.resource_strikes then
    local desc_combat = debug.getinfo(3, 'f').func
    for _, strike in pairs(data.combat.resource_strikes) do
      local cost_string = ''
      for resource, amount in pairs(strike.cost) do
        cost_string = ('%s %d %s'):format(cost_string, amount, resource)
      end
      data.desc:add('#ORANGE#Additonal Strike on hit (costing'..cost_string..'):#LAST#\n')

      local tmp = {combat = strike}
      desc_combat(tmp, data.compare_with, 'combat')
    end
  end

end
class:bindHook('Object:descCombat', hook)

-- Wielder Tooltip
hook = function(self, data)
  local taunt = data.w.taunt_nearby
  if taunt then
    data.desc:add({'color', 'ORANGE'}, 'Taunts Nearby Enemies: ', {'color', 'LAST'},
                  ('Every turn each enemy within %d spaces has a %d%% chance of being taunted. (Both range and chance stack.)')
               :format(taunt.range, taunt.chance),
             true)
  end
end
class:bindHook('Object:descWielder', hook)
