local Console = require("Console")

local model = require("Model").new(10, 10)
local view  = require("View").new(model)



local inputHandlers = {}

inputHandlers[Console.commandsCodes.invalid] = function (command)
    Console.printError("invalid command")
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

local makeCall <const> = function (command)
    inputHandlers[command.code](command)
end

while true do
    Console.printInvitation()

    local command <const> = Console.getInput()
    local status <const>, msg <const> = pcall(makeCall, command)
    if not status then
        Console.printError(msg)
    end
end
