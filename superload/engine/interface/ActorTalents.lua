local _M = loadPrevious(...)
local g = require 'grayswandir.utils'

function _M.changeTalentType(talent, new_type, position)
	_M:getTalentFromId(talent).generic = _M:getTalentTypeFrom(new_type[1]).generic

	table.removeFromList(_M.talents_types_def[talent.type[1]].talents, talent)
	if position then
		table.insert(_M.talents_types_def[new_type[1]].talents, position, talent)
	else
		table.insert(_M.talents_types_def[new_type[1]].talents, talent)
	end
	talent.type = new_type
end

function _M.changeTalentImage(talent, image)
	if not image then
		image = (talent.short_name or talent.name):lower():gsub('[^a-z0-9]', '_')
		image = 'talents/'..image..'.png'
	end
	talent.image = image

	local entity = require 'engine.Entity'
	if fs.exists('/data/gfx/'..image) then
		talent.display_entity = entity.new {
			image = image,
			is_talent = true,}
	else
		talent.display_entity = entity.new {
			image = 'talents/default.png',
			is_talent = true,}
	end
end

return _M
