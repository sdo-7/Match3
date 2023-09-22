local Common = require("Common")
local Impl   = require("Model_impl")

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
t.values      = values
t.tickResults = tickResults

function t.new (field)
    local o = setmetatable({}, {__index = t})
    o.field = field

    local impl = Impl.new(o)

    o.init = function (self)
        return impl:init()
    end
    o.tick = function (self)
        return impl:tick()
    end
    o.move = function (self, from,to)
        return impl:move(from,to)
    end
    o.mix = function (self)
        return impl:mix()
    end
    o.dump = function (self)
        return impl:dump()
    end

    return o
end

return t
