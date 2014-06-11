local _M = loadPrevious(...)

-- Allow resting when below max ammo, even without reload buff.
local restCheck = _M.restCheck
function _M:restCheck()
	local check, reason = restCheck(self)
  if reason == "all resources and life at maximum" and
		self:needReload()
	then return true end
  return check, reason
end

return _M
