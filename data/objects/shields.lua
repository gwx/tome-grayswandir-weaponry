local add_require = function(e)
	if not e.alt_requires then
		e.alt_requires = {table.clone(rawget(e, 'require') or {}, true)}
	end
	for _, req in pairs(e.alt_requires) do
		for i, talent in pairs(req.talent or {}) do
			if type(talent) == 'table' then
				if talent[1] == 'T_ARMOUR_TRAINING' then
					talent[1] = 'T_RIPOSTE'
					talent[2] = 1
				end
			elseif talent == 'T_ARMOUR_TRAINING' then
				req.talent[i] = 'T_RIPOSTE'
			end
		end
	end
end

local base = loading_list.BASE_SHIELD
add_require(base)
for i, e in ipairs(loading_list) do
  if e.subtype == 'shield' then
		add_require(e)
  end
end

for _, name in pairs {'bucklers'} do
  load('/data-grayswandir-weaponry/objects/'..name..'.lua')
end
