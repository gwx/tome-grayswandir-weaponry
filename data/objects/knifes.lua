local base = loading_list.BASE_KNIFE
base.egos = '/data-grayswandir-weaponry/egos/knifes.lua'
for i, e in ipairs(loading_list) do
  if e.subtype == 'dagger' then
    e.egos = '/data-grayswandir-weaponry/egos/knifes.lua'
    e.alt_dammod = {dex = 0.45, {str = 0.45, cun = 0.45},}
  end
end

for _, name in pairs {'swordbreakers', 'throwing-knifes'} do
  load('/data-grayswandir-weaponry/objects/'..name..'.lua')
end
