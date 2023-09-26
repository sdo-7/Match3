local Common = require("Common")
local Vector = require("Vector")

local commandsCodes = {}
commandsCodes.invalid = -1
commandsCodes.quit = 0
commandsCodes.move = 1
commandsCodes = Common.newROTable(commandsCodes)
invalidCommand = {code = commandsCodes.invalid}

local commandsStrings = {}
commandsStrings.quit = 'q'
commandsStrings.move = 'm'
commandsStrings = Common.newROTable(commandsStrings)

local handlers = setmetatable({}, {
    __index = function (t, commandStr)
        local invalidHandler <const> = function (getToken)
            return {code = commandsCodes.invalid}
        end
        local handler <const> = rawget(t, commandStr)

        return handler or invalidHandler
    end
})

handlers[commandsStrings.quit] = function (getToken)
    return {code = commandsCodes.quit}
end

handlers[commandsStrings.move] = function (getToken)
    local x = getToken()
    local y = getToken()
    local d = getToken()
    if not (x and y and d) then return invalidCommand end

    x = tonumber(x)
    y = tonumber(y)
    if not (x and y) then return invalidCommand end

    local from = Vector.newFromInput(x,y)
    local to = Vector.newFromInput(x,y)

        if d=='l' then to.x=to.x-1
    elseif d=='u' then to.y=to.y-1
    elseif d=='r' then to.x=to.x+1
    elseif d=='d' then to.y=to.y+1
    else return invalidCommand end

    return {code=commandsCodes.move, from=from, to=to}
end

local t = {}
t.commandsCodes   = commandsCodes
t.commandsStrings = commandsStrings

function t.print (str)
    print(str or '')
end

function t.printError (str)
    print("Error: " .. str)
end

function t.write (str)
    io.write(str)
end

function t.printInvitation ()
    io.write("enter> ")
end

function t.getInput ()
    local line <const> = io.read("l")
    local getToken = string.gmatch(line, "%g+")
    local code <const> = getToken()

    return handlers[code](getToken)
end

return t
