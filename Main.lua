local Console = require("Console")

local field = require("Field").new(10,10)
local model = require("Model").new(field)
local view  = require("View").new(model)



local inputHandlers = {}

inputHandlers[Console.commandsCodes.invalid] = function (command)
    Console.printError("Invalid command")
end

inputHandlers[Console.commandsCodes.quit] = function (command)
    Console.print("Good bye!")
    os.exit(true)
end

inputHandlers[Console.commandsCodes.move] = function (command)
    local str <const> = string.format("Moving from %s to %s", tostring(command.from), tostring(command.to))
    Console.print(str)
    model:move(command.from, command.to)
    view:update()
end



math.randomseed(0)

model:init()
view:update()

while true do
    Console.printInvitation()

    local command <const> = Console.getInput()

    local makeCall <const> = function ()
        inputHandlers[command.code](command)
    end

    local status <const>, msg <const> = pcall(makeCall)
    if not status then
        Console.printError("Error: " .. msg)
    end
end
