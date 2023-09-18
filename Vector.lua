local t = {}

function t.new (x,y, orientation, length)
    local o = setmetatable({}, t)
    o.x = x
    o.y = y
    o.orientation = orientation
    o.length = length

    return o
end

function t.newFromInput (x,y, orientation, lengt)
    return t.new(x+1,y+1, orientation, length)
end

function t.formatX (x)
    return "" .. x-1
end

function t.formatY (y)
    return "" .. y-1
end

function t:__tostring ()
    local str = "(" .. t.formatX(self.x) .. ":" .. t.formatY(self.y)
    if self.orientation then
        str = str .. ", orientation=" .. self.orientation
    end
    if self.length then
        str = str .. ", length=" .. self.length
    end

    return str .. ")"
end

return t
