local Console = dofile("Console.lua")
local field = dofile("Field.lua").new(10,10)
local model = dofile("Model.lua").new(field)
local view = dofile("View.lua").new(model)



local InputHandler = {}

InputHandler[Console.CMD_QUIT] = function (cmd)
    Console.print("Good bye!")
    os.exit(true)
end

InputHandler[Console.CMD_MOVE] = function (cmd)
    Console.print("Moving from " .. tostring(cmd.from) .. " to " .. tostring(cmd.to))
    model:move(cmd.from, cmd.to)
    view:update()
end

function InputHandler.handleInvalidCommand (cmd)
    Console.printError("Invalid command")
end

function InputHandler.handle (cmd)
    if not cmd then
        InputHandler.handleInvalidCommand(cmd)
    else
        local call <const> = function (cmd) InputHandler[cmd.code](cmd) end
        local status <const>, msg <const> = pcall(call, cmd)
        if not status then Console.printError("Error: " .. msg) end
    end
end



math.randomseed(0)

model:init()
view:printModel()
Console.print()

while true do
    Console.printInvitation()
    local cmd <const> = Console.getInput()
    InputHandler.handle(cmd)
end
