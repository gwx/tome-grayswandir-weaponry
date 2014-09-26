loading_list.BASE_GREATMAUL.egos = '/data-grayswandir-weaponry/egos/2hmaces.lua'
for i, e in ipairs(loading_list) do
  if e.subtype == 'greatmaul' then e.egos = '/data-grayswandir-weaponry/egos/2hmaces.lua' end
end

for _, name in pairs {'2hclubs'} do
  load('/data-grayswandir-weaponry/objects/'..name..'.lua')
end
