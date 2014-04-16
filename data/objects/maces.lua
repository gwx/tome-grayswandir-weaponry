loading_list.BASE_MACE.egos = '/data-grayswandir-weaponry/egos/maces.lua'
for i, e in ipairs(loading_list) do
  if e.subtype == 'mace' then e.egos = '/data-grayswandir-weaponry/egos/maces.lua' end
end

for _, name in pairs {'clubs'} do
  load('/data-grayswandir-weaponry/objects/'..name..'.lua')
end
