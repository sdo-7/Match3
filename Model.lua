local Vector = dofile("Vector.lua")

local MinValue <const> = 0
local MaxValue <const> = 5

local IdleState <const> = 0
local CheckMatchesState <const> = 1
local MoveDownState <const> = 2
local AddNewState <const> = 3

local t = {}
t.BlankValue = '.'

function t.new (field)
    local o = setmetatable({}, {__index = t})
    o.field = field
    o.state = IdleState

    return o
end

function t:init ()
    for y=1, self.field.height do
        for x=1, self.field.width do
            repeat
                local v <const> = math.random(MinValue, MaxValue)
                self.field:set(x,y, v)
            until not self:isAnyMatch(x,y)
        end
    end

    self.state = IdleState
--[[
    self.field:set(2,1,2)
    self.field:set(3,1,1)
    self.field:set(1,2,1)
    self.field:set(2,2,1)
    self.field:set(3,2,2)
    self.field:set(4,2,1)
    self.field:set(5,2,1)
    self.field:set(3,3,1)
    self.field:set(3,4,1)--]]
end

function t:tick ()
    if self.state==IdleState then
        return nil
    elseif self.state==CheckMatchesState then
        local matches = self:getAllMatches()

        local messages = {"Found matches:"}
        if matches then
            for _,vector in ipairs(matches) do
                local msg <const> = tostring(vector)
                messages[#messages+1] = msg

                self.field:setVector(vector, t.BlankValue)
            end

            self.state = MoveDownState
        else
            messages[1] = "No matches found"
            self.state = IdleState
        end

        return messages
    elseif self.state==MoveDownState then
        self:moveDown()
        self.state = AddNewState

        return {"Moving down..."}
    elseif self.state==AddNewState then
        self:addNewElements()
        self.state = CheckMatchesState

        return {"Adding new elements..."}
    end
end

function t:move (from, to)
    assert(self.state == IdleState)

    if from.x<1 or from.x>self.field.width or
       from.y<1 or from.y>self.field.height then
        local msg <const> = "cannot move from " .. from .. "."
        error(msg, 0)
    end
    if to.x<1 or to.x>self.field.width or
       to.y<1 or to.y>self.field.height then
        local msg <const> = "cannot move to " .. to .. "."
        error(msg, 0)
    end

    self.field:swap(from, to)
    if not (self:isAnyMatch(from.x, from.y) or self:isAnyMatch(to.x, to.y)) then
        self.field:swap(from, to)
        local msg <const> = "cannot do this move. It's pointless."
        error(msg, 0)
    end

    self.state = CheckMatchesState
end

function t:mix ()
end

function t:dump ()
    for y=1, self.field.height do
        for x=1, self.field.width do
            local value <const> = self.field:get(x,y)
            io.write((value or 'n') .. ' ')
        end
        io.write('\n')
    end
    io.flush()
end

function t:getHMatch (x, y)
    local v <const> = self.field:get(x,y)~=t.BlankValue and self.field:get(x,y) or nil
    local len = 1
    local left = x
    for p=x-1, 1, -1 do
        local pv <const> = self.field:get(p,y)
        if pv==v then
            len = len + 1
            left = p
        else
            break
        end
    end
    for p=x+1, self.field.width do
        local pv <const> = self.field:get(p,y)
        if pv==v then
            len = len + 1
        else
            break
        end
    end

    return len, left
end

function t:isHMatch (x, y)
    local len <const> = self:getHMatch(x,y)
    return len>2, len
end

function t:getVMatch (x, y)
    local v <const> = self.field:get(x,y)~=t.BlankValue and self.field:get(x,y) or nil
    local len = 1
    local top = y
    for p=y-1, 1, -1 do
        local pv <const> = self.field:get(x,p)
        if pv==v then
            len = len + 1
            top = p
        else
            break
        end
    end
    for p=y+1, self.field.height do
        local pv <const> = self.field:get(x,p)
        if pv==v then
            len = len + 1
        else
            break
        end
    end

    return len, top
end

function t:isVMatch (x, y)
    local len <const> = self:getVMatch(x,y)
    return len>2, len
end

function t:isAnyMatch (x, y)
    return self:isHMatch(x,y) or self:isVMatch(x,y)
end

function t:getAllMatches ()
    local set = {}

    for y=1, self.field.height do
        local x = 1
        while x <= self.field.width do
            local len <const>, left <const> = self:getHMatch(x,y)
            if len>2 then
                local rec <const> = Vector.new(x,y, 'h', len)
                set[#set+1] = rec
                x=x+len
            else
                x=x+1
            end
        end
    end

    for x=1, self.field.width do
        local y = 1
        while y <= self.field.height do
            local len <const>, top <const> = self:getVMatch(x,y)
            if len>2 then
                local rec <const> = Vector.new(x,y, 'v', len)
                set[#set+1] = rec
                y=y+len
            else
                y=y+1
            end
        end
    end

    return #set~=0 and set or nil
end

function t:moveDown ()
    for x=1,self.field.width do
        local lastValueY = nil
        local lastBlankY = nil

        for y=1,self.field.height do
            local value <const> = self.field:get(x, y)
            if value==t.BlankValue then
                lastBlankY = y
            elseif not lastBlankY then
                lastValueY = y
            else
                break
            end
        end

        if lastBlankY and lastValueY then
            for i=0,lastValueY-1 do
                local a <const> = {x=x, y=lastBlankY-i}
                local b <const> = {x=x, y=lastValueY-i}
                self.field:swap(a, b)
            end
        end
    end
end

function t:addNewElements ()
    for y=1, self.field.height do
        for x=1, self.field.width do
            local value <const> = self.field:get(x, y)
            if value==t.BlankValue then
                local v <const> = math.random(MinValue, MaxValue)
                self.field:set(x,y, v)
            end
        end
    end
end

return t
