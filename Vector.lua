local t = {}

local function toString (self)
    local xStr <const> = t.formatX(self.x)
    local yStr <const> = t.formatY(self.y)
    local str = string.format("(%s:%s", xStr, yStr)

    if self.horizontal~=nil then
        local orientationStr <const> = self.horizontal and "horizontal" or "vertical"
        str = string.format("%s, orientation=%s", str, orientationStr)
    end

    if self.length then
        str = string.format("%s, length=%d", str, self.length)
    end

    return str .. ")"
end

local function getLength (self)
    return self.length
end

function t.new (x,y, horizontal, length)
    if type(x)=="table" then
        horizontal = horizontal~=nil and horizontal or x.horizontal
        length = length~=nil and length or x.length
        x,y = x.x, x.y
    end

    local m = {}
    m.__index = t
    m.__tostring = toString
    m.__len = getLength

    local o = setmetatable({}, m)
    o.x = x
    o.y = y
    o.horizontal = horizontal
    o.length = length

    return o
end

function t.newh (x, y, length)
    return t.new(x,y, true, length)
end

function t.newv (x, y, length)
    return t.new(x,y, false, length)
end

local delta <const> = 1

function t.newFromInput (x,y, horizontal, length)
    return t.new(x+delta,y+delta, horizontal, length)
end

function t.formatX (x)
    return tostring(x-delta)
end

function t.formatY (y)
    return tostring(y-delta)
end

function t:isHorizontal ()
    assert(self.horizontal~=nil)
    return self.horizontal
end

function t:isVertical ()
    assert(self.horizontal~=nil)
    return not self.horizontal
end

return t
