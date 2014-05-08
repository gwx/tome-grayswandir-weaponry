local files = {
	'archery', 'buckler', 'thrust', 'sweep', 'magic', 'swordbreakers', 'psi', 'shield'}
for _, name in pairs(files) do
	load('/data-grayswandir-weaponry/talents/'..name..'.lua')
end
