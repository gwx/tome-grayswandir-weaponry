local _M = loadPrevious(...)

-- Allow resting when below max ammo, even without reload buff.
local restCheck = _M.restCheck
function _M:restCheck()
  if config.settings.tome.grayswandir_weaponry_alt_reload ~= false then
    if self:needReload() then return true end
  end
  return restCheck(self)
end

return _M
