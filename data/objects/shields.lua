local base = loading_list.BASE_SHIELD
base.alt_requires = {{talent = {T_RIPOSTE, 1}}}
for i, e in ipairs(loading_list) do
  if e.subtype == 'shield' then
		e.alt_requires = {{talent = {T_RIPOSTE, 1}}}
  end
end

for _, name in pairs {'bucklers'} do
  load('/data-grayswandir-weaponry/objects/'..name..'.lua')
end
