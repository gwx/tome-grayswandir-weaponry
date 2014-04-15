local filters, adds
adds = {
  SWORD_WEAPON = 'rapier',
  AXE_WEAPON = {'spear', 'greatspear'},
  MAUL_WEAPON = {'club', 'greatclub'},
  KNIFE_WEAPON = {'swordbreaker', 'whip', 'throwing knives',},
  GEMSTORE = 'aurastone',
  ZIGUR_SWORD_WEAPON = 'rapier',
  ZIGUR_AXE_WEAPON = {'spear', 'greatspear'},
  ZIGUR_MACE_WEAPON = {'club', 'greatclub'},
  ZIGUR_KNIFE_WEAPON = {'swordbreaker', 'whip', 'throwing knives',},}
for store, weapons in pairs(adds) do
  if _G.type(weapons) ~= 'table' then weapons = {weapons} end
  local store = loading_list[store].store
  if _G.type(store.filters) == 'function' then
    store.filters = {store.filters()}
  end
  -- Add each weapon subtype to the filters.
  for _, subtype in pairs(weapons) do
    local filter = {type = 'weapon', subtype = subtype, id = true, tome_drops = 'store'}
    table.insert(store.filters, filter)
  end
end

filters = loading_list.ARENA_SHOP.store.filters
adds = {'rapier', 'club', 'greatclub', 'swordbreaker', 'whip', 'trident', 'spear', 'greatspear', 'throwing knives', 'aurastone',}
for i, subtype in pairs(adds) do
  table.insert(filters, {type = 'weapon', subtype = subtype, id = true, tome_drops = 'boss'})
end
