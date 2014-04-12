-- Hack all daggers to allow cun instead of str in dammod.
for i, e in ipairs(loading_list) do
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
end
