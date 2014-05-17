-- Buckler Trees
local x = {
	Bulwark = {false, 0.3,},
	['Arcane Blade'] = {true, 0.1,},
	Rogue = {true, 0.1,},
	Marauder = {true, 0.1,},
	['Temporal Warden'] = {true, 0.1,},}
for class, value in pairs(x) do
	getBirthDescriptor('subclass', class)
		.talents_types['technique/buckler-offense'] = value
end
