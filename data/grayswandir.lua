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
  Set the nested value in a table, creating empty tables as needed.
]=]
function _M.set(table, ...)
  if type(table) ~= 'table' then return false end
  local args = {...}
  for i = 1, #args - 2 do
    local key = args[i]
    local subtable = table[key]
    if not subtable then
      subtable = {}
      table[key] = subtable
    end
    table = subtable
  end
  table[args[#args - 1]] = args[#args]
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

--[=[
  If the table has the exact given value.
]=]
function _M.hasv(table, value)
  for _, v in pairs(table) do
    if v == value then return true end
  end
  return false
end

--[=[
  Increment the given value by 1, creating it if it doesn't exist.
]=]
function _M.inc(table, key, amount)
  table[key] = (table[key] or 0) + (amount or 1)
  if table[key] <= 0 then table[key] = nil end
end

--[=[
  Decrement the given value by 1, setting to nil if it reaches 0.
]=]
function _M.dec(table, key, amount)
  _M.inc(table, key, -(amount or 1))
end

return _M
