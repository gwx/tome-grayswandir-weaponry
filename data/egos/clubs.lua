load('/data/general/objects/egos/weapon.lua')

-- Make plain weapon egos rarer.
for i, ego in ipairs(loading_list) do
  if ego.rarity then ego.rarity = ego.rarity * 2 end
end

load('/data/general/objects/egos/mindstars.lua')

-- Get rid of mindstar set egos.
for i, ego in ipairs(loading_list) do
  if ego.set_list or ego.name == 'mitotic ' then ego.rarity = nil end
end

load('/data-grayswandir-weaponry/egos/1hweapons.lua')
load('/data-grayswandir-weaponry/egos/all-clubs.lua')
