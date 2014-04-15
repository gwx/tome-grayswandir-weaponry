loading_list.BASE_LONGSWORD.egos = '/data-grayswandir-weaponry/egos/swords.lua'
for i, e in ipairs(loading_list) do
  if e.subtype == 'longsword' then e.egos = '/data-grayswandir-weaponry/egos/swords.lua' end
end

for _, name in pairs {'rapiers'} do
  load('/data-grayswandir-weaponry/objects/'..name..'.lua')
end
