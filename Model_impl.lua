local Vector             = require("Vector")
local Model_stateMachine = require("Model_stateMachine")

local t = {}

function t.new (model)
    local o = setmetatable({}, {__index = t})
    o.model = model
    o = Model_stateMachine.new(o)

    return o
end

function t:init ()
    for y=1, self.model.field.height do
        for x=1, self.model.field.width do
            repeat
                local value <const> = self:randomValue()
                self.model.field:set(value, x,y)
            until not self:isAnyMatchAt(x,y)
        end
    end

    self.state = self.states.idle
end

function t:move (from, to)
    assert(self.state == self.states.idle)

    local f = function (coordinates)
        local isValid = self.model.field:contains(coordinates)
        if not isValid then
            local msg <const> = string.format("cannot move to/from %s.", tostring(coordinates))
            error(msg, 0)
        end
    end

    f(from)
    f(to)

    self.model.field:swap(from, to)
    local anyMatches <const> = self:isAnyMatchAt(from) or self:isAnyMatchAt(to)
    if not anyMatches then
        self.model.field:swap(from, to)

        local msg <const> = "cannot do this move. It's pointless."
        error(msg, 0)
    end

    self.state = self.states.checkMatches
end

function t:mix ()
end

function t:dump ()
    for y=1, self.model.field.height do
        for x=1, self.model.field.width do
            local value <const> = self.model.field:get(x,y)
            local str <const> = string.format(" %s", (value or 'n'))
            io.write(str)
        end
        io.write('\n')
    end
    io.flush()
end

function t:randomValue ()
    return math.random(self.model.values.min, self.model.values.max)
end

function t:getMatchAt (x,y, horizontal)
    local vector            = Vector.new(x,y, horizontal)
    local varName   <const> = vector:isHorizontal() and 'x' or 'y'
    local limit     <const> = vector:isHorizontal() and self.model.field.width or self.model.field.height
    local origValue <const> = self.model.field:get(vector)

    local f = function (delta, limit)
        local coordinates = {x=vector.x, y=vector.y}
        local coordinate  = vector[varName]

        for i=coordinate+delta, limit, delta do
            coordinates[varName] = i
            local curValue <const> = self.model.field:get(coordinates)

            if curValue~=origValue then
                break
            end

            coordinate = i
        end

        return coordinate
    end

    local first  <const> = f(-1,     1)
    local last   <const> = f( 1, limit)
    local length <const> = last - first + 1

    vector[varName] = first
    vector.length = length

    local match <const> = length > 2
    return match, vector
end

function t:getHMatchAt (x, y)
    return self:getMatchAt(x,y, true)
end

function t:isHMatchAt (x, y)
    return (self:getHMatchAt(x,y))
end

function t:getVMatchAt (x, y)
    return self:getMatchAt(x,y, false)
end

function t:isVMatchAt (x, y)
    return (self:getVMatchAt(x,y))
end

function t:isAnyMatchAt (x, y)
    if not y then
        x,y = x.x, x.y
    end

    return self:isHMatchAt(x,y) or self:isVMatchAt(x,y)
end

function t:getAllMatches ()
    local set = {}
    local f = function (vector)
        vector = Vector.new(vector)
        local xInfo    <const> = {name='x', limit=self.model.field.width}
        local yInfo    <const> = {name='y', limit=self.model.field.height}
        local slowInfo <const> = vector:isHorizontal() and yInfo or xInfo
        local fastInfo <const> = vector:isHorizontal() and xInfo or yInfo

        for slow=1, slowInfo.limit do
            local fast=1
            while fast<=fastInfo.limit do
                vector[slowInfo.name] = slow
                vector[fastInfo.name] = fast
                local match <const>, matchVector <const> = self:getMatchAt(vector)

                if match then
                    set[#set+1] = matchVector
                end

                fast = fast + matchVector.length
            end
        end
    end

    f(Vector.newh())
    f(Vector.newv())

    set = #set~=0 and set or nil
    return set
end

return t
