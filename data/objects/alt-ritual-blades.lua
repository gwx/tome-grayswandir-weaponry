local g = require 'grayswandir.utils'

for i, e in ipairs(loading_list) do
  -- Hack all ritual blades to use their own talented field
  local combat = e.combat
  if e.subtype == 'ritual blade' and g.get(e, 'combat', 'talented') == 'knife' then
    e.combat.talented = 'ritual-blade'
    e.combat.accuracy_effect = 'staff'
  end
end
