local Common = require("Common")
local Impl   = dofile("./Model/Impl.lua")

local values = {}
values.blank = '.'
values.min   = 1
values.max   = 6
values = Common.newROTable(values)

local tickResults = {}
tickResults.foundMatches     = 1
tickResults.foundNoMatches   = 2
tickResults.movedDown        = 3
tickResults.addedNewElements = 4
tickResults = Common.newROTable(tickResults)


local t = {}
t.__index     = t
t.values      = values
t.tickResults = tickResults

function t:init ()
    return self._impl:init();
end

function t:tick ()
    return self._impl:tick()
end

function t:move (from, to)
    return self._impl:move(from, to)
end

function t:mix ()
    return self._impl:mix()
end

function t:dump ()
    return self._impl:dump()
end

function t.new (width, height)
    local o = setmetatable({}, t)
    o._impl = Impl.new(o, width,height)

    return o
end

return t
