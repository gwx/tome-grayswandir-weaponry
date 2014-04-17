local g = require 'grayswandir.utils'

load '/data/general/objects/egos/bow.lua'

-- Make ammo egos apply to new archery values.
for _, e in pairs(loading_list) do
  local speed = g.get(e, 'wielder', 'ammo_reload_speed')
  if speed and not e.wielder.weapon_reload_speed then
    e.wielder.weapon_reload_speed = speed
  end
end
