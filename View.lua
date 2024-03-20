local Common  = require("Common")
local Vector  = require("Vector")
local Console = require("Console")
local Model   = require("Model")

local values = {[Model.values.blank]=' '}
for i=Model.values.min, Model.values.max do
    local c <const> = string.byte('A')
    values[i] = string.char(c - 1 + i)
end
values = Common.newROTable(values)

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

local function printModel (model)
    Console.write("  |")
    for x=1, model.field.width do
        local xStr <const> = Vector.formatX(x)
        local str <const> = string.format("%2d", xStr)
        Console.write(str)
    end
    Console.print()

    Console.write("--+")
    for x=1, model.field.width do
        Console.write("--")
    end
    Console.print()

    for y=1, model.field.height do
        local yStr <const> = Vector.formatY(y)
        local str <const> = string.format("%2d|", yStr)
        Console.write(str)

        for x=1, model.field.width do
            local valueCode <const> = model.field:get(x,y)
            local value <const> = values[valueCode]
            local str <const> = string.format(' %s', value)
            Console.write(str)
        end
        Console.print()
    end
end

local t = {}
t.__index = t
t.values = values

function t:update ()
    while true do
        printModel(self.model._impl)

        local code <const>, data <const> = self.model:tick()
        if not code then break end

        printTickData(code, data)
    end

    Console.print()
end

function t.new (model)
    local o = setmetatable({}, t)
    o.model = model

    return o
end

return t
