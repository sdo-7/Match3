local Common = require("Common")
local Vector = require("Vector")

local states = {}
states.idle         = 0
states.checkMatches = 1
states.moveDown     = 2
states.addNew       = 3
states = Common.newROTable(states)

local handlers = {}

handlers[states.idle] = function (impl)
    return nil
end

handlers[states.checkMatches] = function (impl)
    local matches <const> = impl:getAllMatches()

    if not matches then
        impl.state = impl.states.idle
        return impl.model.tickResults.foundNoMatches
    end

    for _,vector in ipairs(matches) do
        impl.model.field:setVector(impl.model.values.blank, vector)
    end

    impl.state = impl.states.moveDown
    return impl.model.tickResults.foundMatches, matches
end

handlers[states.moveDown] = function (impl)
    for x=1, impl.model.field.width do
        local blankCoordinate = nil

        for y=impl.model.field.height, 1, -1 do
            local value <const> = impl.model.field:get(x, y)

            if value==impl.model.values.blank then
                blankCoordinate = blankCoordinate or y
            elseif blankCoordinate then
                local a <const> = Vector.new(x, y)
                local b <const> = Vector.new(x, blankCoordinate)
                impl.model.field:swap(a, b)

                blankCoordinate = blankCoordinate - 1
            end
        end
    end

    impl.state = impl.states.addNew
    return impl.model.tickResults.movedDown
end

handlers[states.addNew] = function (impl)
    for y=1, impl.model.field.height do
        for x=1, impl.model.field.width do
            local value <const> = impl.model.field:get(x, y)

            if value==impl.model.values.blank then
                local newValue <const> = impl:randomValue()

                impl.model.field:set(newValue, x,y)
            end
        end
    end

    impl.state = impl.states.checkMatches
    return impl.model.tickResults.addedNewElements
end

local t = {}

function t.new (impl)
    impl.states = states
    impl.state  = impl.states.idle
    impl.tick   = function (impl)
        return handlers[impl.state](impl)
    end

    return impl
end

return t
