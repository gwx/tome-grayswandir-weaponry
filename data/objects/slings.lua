loading_list.BASE_SLING.egos = '/data-grayswandir-weaponry/egos/slings.lua'
loading_list.BASE_SHOT.egos = '/data-grayswandir-weaponry/egos/shots.lua'
for i, e in ipairs(loading_list) do
  if e.subtype == 'sling' then e.egos = '/data-grayswandir-weaponry/egos/slings.lua' end
  if e.subtype == 'shot' then e.egos = '/data-grayswandir-weaponry/egos/shots.lua' end
end
