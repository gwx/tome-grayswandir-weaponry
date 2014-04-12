local g = require 'grayswandir'

load('/data/general/objects/egos/ammo.lua')

-- Make ammo egos apply to new archery values.
for i, e in ipairs(loading_list) do
  local speed = g.get(e, 'wielder', 'ammo_reload_speed')
  if speed and not e.reload_speed then
    e.reload_speed = speed
  end
end
