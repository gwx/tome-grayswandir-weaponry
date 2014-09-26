local g = require 'grayswandir.utils'

-- Buckler Trees
local x = {
	Bulwark = {false, 0.3,},
	['Arcane Blade'] = {true, 0.1,},
	Rogue = {true, 0.1,},
	Marauder = {true, 0.1,},
	Skirmisher = {true, 0.3,},
	['Temporal Warden'] = {true, 0.1,},}

for class, value in pairs(x) do
	class = getBirthDescriptor('subclass', class)
	if config.settings.tome.grayswandir_weaponry_bucklers ~= false then
		class.talents_types['technique/buckler-offense'] = value
	end
	-- If turned off, cache it for when they're turned on.
	g.set(class, 'copy', 'learn_bucklers', value)
end

-- Skirmishers actually start out with a buckler, maybe?
if config.settings.tome.grayswandir_weaponry_bucklers ~= false then
	local copy = getBirthDescriptor('subclass', 'Skirmisher').copy
	-- Find equip resolver.
	local equip
	for k, v in pairs(copy) do
		if v.__resolver == 'equip' then
			equip = v
			break
		end
	end
	-- Find the shield
	local shield
	if equip then
		for k, v in pairs(equip[1]) do
			if type(v) == 'table' and v.subtype == 'shield' then
				shield = v
				break
			end
		end
	end
	-- Change to be a buckler.
	if shield then
		shield.subtype = 'buckler'
		shield.name = 'iron buckler'
	end
end
