local t = {}
t.__index = t

function t.new (x, y)
  if type(x)=='table' then
    x, y = x.x, x.y
  end

  local o = setmetatable({}, t)
  o.x = x
  o.y = y

  return o
end

return t
