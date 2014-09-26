local _M = loadPrevious(...)

--[[
-- Merge special_on_crit values.
_M:addEgoRule("object", function(dvalue, svalue, key, dst, src, rules, state)
	-- Only work on the special_on_* keys.
	if key ~= 'special_on_hit' and key ~= 'special_on_crit' and key ~= 'special_on_kill' then return end
	-- If the special isn't a table, make it an empty one.
	if type(dvalue) ~= 'table' then dvalue = {} end
	if type(svalue) ~= 'table' then svalue = {} end
	-- If the special is a single special, wrap it to allow multiple.
	if dvalue.fct then dvalue = {dvalue} end
	if svalue.fct then svalue = {svalue} end
	-- Update
	dst[key] = dvalue
	-- Recurse with always append
	rules = table.clone(rules)
	table.insert(rules, 1, table.rules.append)
	return table.rules.recurse(dvalue, svalue, key, dst, src, rules, state)
end)
--]]

return _M
