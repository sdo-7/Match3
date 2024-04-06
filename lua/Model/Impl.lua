local Vector = require("Vector")
local Field = dofile('./Model/Field.lua')
local StateMachine = dofile("./Model/StateMachine.lua")

local t = {}
t.__index = t

function t:init ()
    for y=1, self.field.height do
        for x=1, self.field.width do
            repeat
                local value <const> = self:randomValue()
                self.field:set(value, x,y)
            until not self:isAnyMatchAt(x,y)
        end
    end
end

function t:tick ()
    return self.stateMachine:handle()
end

function t:move (from, to)
    assert(self.stateMachine.current == 'idle')

    local f <const> = function (coordinates)
        local isValid = self.field:contains(coordinates)
        if not isValid then
            local msg <const> = string.format("cannot move to/from %s.", tostring(coordinates))
            error(msg, 0)
        end
    end

    f(from)
    f(to)

    self.field:swap(from, to)
    local anyMatches <const> = self:isAnyMatchAt(from) or self:isAnyMatchAt(to)
    if not anyMatches then
        self.field:swap(from, to)

        local msg <const> = "cannot do this move. It's pointless."
        error(msg, 0)
    end

    self.stateMachine.current = 'checkMatches'
end

function t:mix ()
end

function t:dump ()
    for y=1, self.field.height do
        for x=1, self.field.width do
            local value <const> = self.field:get(x,y)
            local str <const> = string.format("%s, ", (value or 'n'))
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
    local limit     <const> = vector:isHorizontal() and self.field.width or self.field.height
    local origValue <const> = self.field:get(vector)

    local f <const> = function (delta, limit)
        local coordinates = Vector.new(vector)
        local coordinate  = vector[varName]

        for i=coordinate+delta, limit, delta do
            coordinates[varName] = i
            local curValue <const> = self.field:get(coordinates)

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
    return self:isHMatchAt(x,y) or self:isVMatchAt(x,y)
end

function t:getMatchesFor (horizontal)
    local xInfo    <const> = {name='x', limit=self.field.width}
    local yInfo    <const> = {name='y', limit=self.field.height}
    local slowInfo <const> = horizontal and yInfo or xInfo
    local fastInfo <const> = horizontal and xInfo or yInfo

    local vector = Vector.new(nil, nil, horizontal)
    local set    = {}

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

    set = #set~=0 and set or nil
    return set
end

function t:getHMatches ()
    return self:getMatchesFor(true)
end

function t:getVMatches ()
    return self:getMatchesFor(false)
end

function t:getAllMatches ()
    local matches  = self:getHMatches()
    local vMatches = self:getVMatches()

    if not vMatches then
        return matches
    end

    if not matches then
        return vMatches
    end

    for _,vector in ipairs(vMatches) do
        matches[#matches+1] = vector
    end

    return matches
end

function t.new (model, width,height)
    local o = setmetatable({}, t)
    o.model = model
    o.field = Field.new(width, height)
    o.stateMachine = StateMachine.new(o)

    return o
end

return t
