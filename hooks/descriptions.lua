local hook
local stats = require 'engine.interface.ActorStats'

-- Combat Tooltip
hook = function(self, data)
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

      -- Replace the line.
      local dm = {}
      for stat, i in pairs(use_actor:getDammod(data.combat)) do
        dm[#dm+1] = ('%d%% %s'):format(i * 100, stats.stats_def[stat].short_name:capitalize())
      end
      data.desc[i] = ('Uses stat%s: %s'):format(#dm > 1 and 's' or '',table.concat(dm, ', '))

      break
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
