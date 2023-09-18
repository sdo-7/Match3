local Console = dofile("Console.lua")
local Vector = dofile("Vector.lua")

local function printMessages (messages)
    for i,msg in ipairs(messages) do
        Console.print(msg)
    end
end

local t = {}

function t.new (model)
    local o = setmetatable({}, {__index = t})
    o.model = model
    o.values = {[model.BlankValue]='.',[0]='A', 'B', 'C', 'D', 'E', 'F'}

    return o
end

function t:update ()
    repeat
        self:printModel(self.model)
        local messages <const> = self.model:tick()
        if messages then
            printMessages(messages)
        end
    until not messages

    Console.print("")
end

function t:printModel ()
    Console.write("  |")
    for x=1,self.model.field.width do
        local str <const> = string.format("%2d", Vector.formatX(x))
        Console.write(str)
    end
    Console.print("")

    Console.write("--+")
    for x=1,self.model.field.width do
        Console.write("--")
    end
    Console.print("")

    for y=1,self.model.field.height do
        Console.write(string.format("%2d|", Vector.formatY(y)))
        for x=1,self.model.field.width do
            local value <const> = self.model.field:get(x,y)
            local str <const> = ' ' .. self.values[value]
            Console.write(str)
        end
        Console.print("")
    end
end

return t
