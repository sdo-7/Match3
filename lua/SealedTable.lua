local t = {}

local function newindex (table, key, value)
  local msg <const> = 'Attempting to change a sealed table'
  error(msg, 2)
end

function t.new (table)
  local m <const> = {
    __index = table,
    __newindex = newindex
  }

  local o <const> = setmetatable({}, m)
  return o
end

return t
