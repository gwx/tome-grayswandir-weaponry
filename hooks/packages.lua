local packages

-- Mark all the superloads we're going to use.
packages = {'Actor', 'Object', 'Player', 'interface.Archery', 'interface.Combat',}
for _, name in pairs(packages) do
	package.loaded['mod.class.'..name] = nil
end

-- Add packages in the data/packages folder.
packages = {'utils', 'resolvers'}
for _, name in pairs(packages) do
	package.preload['grayswandir.'..name] =
		loadfile('/data-grayswandir-weaponry/packages/'..name..'.lua')
end
