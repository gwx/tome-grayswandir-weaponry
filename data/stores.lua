local filters, adds, store
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
  store = loading_list[store].store
	local as_function = false
	-- Convert from function to table.
  if _G.type(store.filters) == 'function' then
    store.filters = {store.filters()}
		as_function = true
  end
  -- Add each weapon subtype to the filters.
  for _, subtype in pairs(weapons) do
    local filter = {type = 'weapon', subtype = subtype, id = true, tome_drops = 'store'}
    table.insert(store.filters, filter)
    -- Increase the number of items to make up for the variety.
    store.nb_fill = (store.nb_fill or 10) + 5
  end
	-- Convert back from table to function.
	if as_function then
		local filters = store.filters
		store.filters = function() return filters end
	end
end

store = loading_list.ANGOLWEN_STAFF_WAND.store
store.nb_fill = 30
store.filters = {
  {type = 'weapon', subtype = 'staff', id = true, tome_drops = 'store',},
  {type = 'weapon', subtype = 'aurastone', id = true, tome_drops = 'store',},
  {type = 'charm', subtype = 'wand', id = true, tome_drops = 'store',},}
store.post_filter = function(e)
  return e.subtype == 'staff' or rng.percent(30)
end


filters = loading_list.ARENA_SHOP.store.filters
adds = {'rapier', 'club', 'greatclub', 'swordbreaker', 'whip', 'trident', 'spear', 'greatspear', 'throwing knives', 'aurastone',}
for i, subtype in pairs(adds) do
  table.insert(filters, {type = 'weapon', subtype = subtype, id = true, tome_drops = 'boss'})
end
