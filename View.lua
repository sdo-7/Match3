local Common  = require("Common")
local Console = require("Console")
local Vector  = require("Vector")
local Model   = require("Model")

local tickDataPrinters = {}

tickDataPrinters[Model.tickResults.foundMatches] = function (data)
    Console.print("Found matches:")
    for _,v in ipairs(data) do
        Console.print(tostring(v))
    end
end

tickDataPrinters[Model.tickResults.foundNoMatches] = function (data)
    Console.print("Found no matches:")
end

tickDataPrinters[Model.tickResults.movedDown] = function (data)
    Console.print("Moved down:")
end

tickDataPrinters[Model.tickResults.addedNewElements] = function (data)
    Console.print("Added new elements:")
end

local function printTickData (code, data)
    tickDataPrinters[code](data)
end

local values = {[Model.values.blank]=' '}
for i=Model.values.min, Model.values.max do
    values[i] = string.char(0x41 + i)
end

local t = {}
t.values = Common.addROTable(values)

function t.new (model)
    local o = setmetatable({}, {__index = t})
    o.model = model

    return o
end

function t:update ()
    while true do
        self:printModel(self.model)

        local code <const>, data <const> = self.model:tick()
        if not code then break end

        printTickData(code, data)
    end

    Console.print()
end

function t:printModel ()
    Console.write("  |")
    for x=1,self.model.field.width do
        local xStr <const> = Vector.formatX(x)
        local str <const> = string.format("%2d", xStr)
        Console.write(str)
    end
    Console.print()

    Console.write("--+")
    for x=1, self.model.field.width do
        Console.write("--")
    end
    Console.print()

    for y=1, self.model.field.height do
        local yStr <const> = Vector.formatY(y)
        local str <const> = string.format("%2d|", yStr)
        Console.write(str)

        for x=1, self.model.field.width do
            local value <const> = self.model.field:get(x,y)
            local valueStr <const> = self.values[value]
            local str <const> = string.format(' %s', valueStr)
            Console.write(str)
        end
        Console.print()
    end
end

return t
