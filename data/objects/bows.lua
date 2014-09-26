loading_list.BASE_LONGBOW.egos = '/data-grayswandir-weaponry/egos/bows.lua'
loading_list.BASE_ARROW.egos = '/data-grayswandir-weaponry/egos/arrows.lua'
for i, e in ipairs(loading_list) do
  if e.subtype == 'longbow' then e.egos = '/data-grayswandir-weaponry/egos/bows.lua' end
  if e.subtype == 'arrow' then e.egos = '/data-grayswandir-weaponry/egos/arrows.lua' end
end
