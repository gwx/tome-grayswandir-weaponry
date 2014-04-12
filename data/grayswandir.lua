module('grayswandir', package.seeall)

--[=[
  Decends recursively through a table by the given list of keys.

  1st return: The first non-table value found, or the final value if
  we ran out of keys.

  2nd return: If the list of keys was exhausted

  Meant to replace multiple ands to get a value:
  "a and a.b and a.b.c" turns to "rget(a, 'b', 'c')"
]=]
function _M.get(table, ...)
  if type(table) ~= 'table' then return table, false end
  for _, key in ipairs({...}) do
    if type(table) ~= 'table' then return table, false end
    table = table[key]
  end
  return table, true
end

--[=[
  Return the result of mapping f across the values of source.
]=]
function _M.mapv(source, f)
  local result = {}
  for k, v in pairs(source) do
    result[k] = f(v)
  end
  return result
end

return _M
