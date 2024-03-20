local Vector = require("Vector")

local handlers = {}

handlers['idle'] = function (impl)
    return nil
end

handlers['checkMatches'] = function (impl)
    local matches <const> = impl:getAllMatches()

    if not matches then
        impl.stateMachine.current = 'idle'
        return impl.model.tickResults.foundNoMatches
    end

    for _,vector in ipairs(matches) do
        impl.field:setVector(impl.model.values.blank, vector)
    end

    impl.stateMachine.current = 'moveDown'
    return impl.model.tickResults.foundMatches, matches
end

handlers['moveDown'] = function (impl)
    for x=1, impl.field.width do
        local blankCoordinate = nil

        for y=impl.field.height, 1, -1 do
            local value <const> = impl.field:get(x, y)

            if value==impl.model.values.blank then
                blankCoordinate = blankCoordinate or y
            elseif blankCoordinate then
                local a <const> = Vector.new(x, y)
                local b <const> = Vector.new(x, blankCoordinate)
                impl.field:swap(a, b)

                blankCoordinate = blankCoordinate - 1
            end
        end
    end

    impl.stateMachine.current = 'addNew'
    return impl.model.tickResults.movedDown
end

handlers['addNew'] = function (impl)
    for y=1, impl.field.height do
        for x=1, impl.field.width do
            local value <const> = impl.field:get(x, y)

            if value==impl.model.values.blank then
                local newValue <const> = impl:randomValue()

                impl.field:set(newValue, x,y)
            end
        end
    end

    impl.stateMachine.current = 'checkMatches'
    return impl.model.tickResults.addedNewElements
end

local t = {}
t.__index = t

function t:handle ()
    local handler <const> = handlers[self.current]
    return handler(self._impl)
end

function t.new (impl)
    local o = setmetatable({}, t)
    o._impl = impl
    o.current = 'idle'

    return o
end

return t
