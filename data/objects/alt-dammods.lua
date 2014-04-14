local g = require 'grayswandir'
local glovetab = { dam=1, atk=1, apr=0, physcrit=0, physspeed =0.6, dammod={str=1}, damrange=1.1 }

for i, e in ipairs(loading_list) do
  -- Hack all daggers to allow cun instead of str in dammod.
  local combat = e.combat
  if e.subtype == 'dagger' and combat and combat.dammod and not combat.alt_dammod then
    combat.alt_dammod = {}
    for stat, mod in pairs(combat.dammod) do
      if stat ~= 'str' then combat.alt_dammod[stat] = mod end
    end
    local strmod = combat.dammod.str
    if strmod then
      table.insert(combat.alt_dammod, {str = strmod, cun = strmod})
    end
  end

  -- Hack all the gloves to display proper dammod.
  if e.subtype == 'hands' and not g.get(e, 'wielder', 'combat', 'display_add') then
    e.wielder.combat.display_add = glovetab
  end

end
