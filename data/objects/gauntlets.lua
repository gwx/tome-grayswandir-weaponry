local g = require 'grayswandir.utils'
local addtab = { dam=1, atk=1, apr=0, physcrit=0, physspeed =0.6, dammod={str=1}, damrange=1.1 }
--loading_list.BASE_GAUNTLETS.egos = '/data-grayswandir-weaponry/egos/gauntlets.lua'
g.set(loading_list.BASE_GAUNTLETS, 'wielder', 'combat', 'display_add', addtab)
for i, e in ipairs(loading_list) do
  if e.subtype == 'hands' and e.metallic then
    --e.egos = '/data-grayswandir-weaponry/egos/gauntlets.lua'
    e.wielder.combat.display_add = addtab
  end
end
