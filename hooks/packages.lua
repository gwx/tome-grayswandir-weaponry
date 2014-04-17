-- Add packages in the data/packages folder.
local packages = {'utils', 'resolvers'}
for _, name in pairs(packages) do
	package.preload['grayswandir.'..name] =
		loadfile('/data-grayswandir-weaponry/packages/'..name..'.lua')
end
