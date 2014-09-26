local hook = function(self, data)
	for _, name in pairs {'granted-abilities', 'scale',} do
		require('grayswandir.'..name)
	end
end
class:bindHook('ToME:load', hook)
