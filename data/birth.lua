local g = require 'grayswandir.utils'

-- Buckler Trees
local x = {
	Bulwark = {false, 0.3,},
	['Arcane Blade'] = {true, 0.1,},
	Rogue = {true, 0.1,},
	Marauder = {true, 0.1,},
	['Temporal Warden'] = {true, 0.1,},}


for class, value in pairs(x) do
	class = getBirthDescriptor('subclass', class)
	if config.settings.tome.grayswandir_weaponry_bucklers ~= false then
		class.talents_types['technique/buckler-offense'] = value
	end
	-- If turned off, cache it for when they're turned on.
	g.set(class, 'copy', 'learn_bucklers', value)
end
