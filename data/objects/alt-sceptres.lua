local g = require 'grayswandir'

for i, e in ipairs(loading_list) do
  -- Hack all sceptres to use their own talented field
  local combat = e.combat
  if (e.subtype == 'sceptre' and g.get(e, 'combat', 'talented') == 'mace')
    or e.name == 'Quartz Sceptre'
  then
    e.combat.talented = 'sceptre'
    e.combat.accuracy_effect = 'mace'
  end
end
