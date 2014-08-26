local files = {
	'archery', 'thrust', 'sweep', 'magic', 'swordbreakers', 'psi', 'shield', 'buckler-offense', 'buckler',
	'abilities',}
for _, name in pairs(files) do
	load('/data-grayswandir-weaponry/talents/'..name..'.lua')
end
