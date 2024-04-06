local SealedTable = require('SealedTable')
local Impl = dofile('./Model/Impl.lua')

local values = SealedTable.new({
    blank = '.',
    min = 1,
    max = 6,
})

local tickResults = SealedTable.new({
    foundMatches = 'foundMatches',
    foundNoMatches = 'foundNoMatches',
    movedDown = 'movedDown',
    addedNewElements = 'addedNewElements',
})


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
