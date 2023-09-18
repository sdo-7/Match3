local t = {}

local function toIndex (width, x, y)
    return (y-1)*width + x
end

function t.new (width, height)
    local m = {}
    m.__index = t
    m.__len = function (self)
        return self.width * self.height
    end

    local o = setmetatable({}, m)
    o.width = width
    o.height = height

    return o
end

function t:get (x, y)
    local index <const> = toIndex(self.width, x, y)
    return self[index]
end

function t:set (x, y, value)
    local index <const> = toIndex(self.width, x, y)
    self[index] = value
end

function t:setVector (vector, value)
    for i=0,vector.length-1 do
        local x <const> = vector.orientation=='h' and vector.x+i or vector.x
        local y <const> = vector.orientation=='v' and vector.y+i or vector.y
        local index <const> = toIndex(self.width, x, y)
        self[index] = value
    end
end

function t:swap (a, b)
    local av <const> = self:get(a.x, a.y)
    local bv <const> = self:get(b.x, b.y)
    self:set(a.x, a.y, bv)
    self:set(b.x, b.y, av)
end

return t
