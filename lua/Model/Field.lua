local function toIndex (width, x,y)
    if not y then
        x,y = x.x, x.y
    end

    return (y-1)*width + x
end

local t = {}
t.__index = t

t.__len = function (self)
    local length = self.width * self.height
    return length
end

function t:get (x, y)
    local index <const> = toIndex(self.width, x,y)
    local value <const> = self[index]
    return value
end

function t:set (value, x,y)
    local index <const> = toIndex(self.width, x,y)
    self[index] = value
end

function t:setVector (value, vector)
    local coordinates = {x=vector.x, y=vector.y}
    local varName <const> = vector:isHorizontal() and 'x' or 'y'

    for i=1, #vector do
        local index <const> = toIndex(self.width, coordinates)
        self[index] = value
        coordinates[varName] = coordinates[varName] + 1
    end
end

function t:swap (a, b)
    local av <const> = self:get(a)
    local bv <const> = self:get(b)
    self:set(bv, a)
    self:set(av, b)
end

function t:contains (x, y)
    if not y then
        x,y = x.x, x.y
    end

    local isInside <const> = x>=1 and x<=self.width and
                             y>=1 and y<=self.height
    return isInside
end

function t.new (width, height)
    local o = setmetatable({}, t)
    o.width = width
    o.height = height

    return o
end

return t
