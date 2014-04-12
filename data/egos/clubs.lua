load('/data/general/objects/egos/weapon.lua')

-- Make plain weapon egos rarer.
for i, ego in ipairs(loading_list) do
  if ego.rarity then ego.rarity = ego.rarity * 2 end
end

load('/data-grayswandir-weaponry/egos/1hweapons.lua')
load('/data/general/objects/egos/mindstars.lua')
load('/data-grayswandir-weaponry/egos/all-clubs.lua')
