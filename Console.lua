local Vector = require("Vector")

local t = {}

t.CMD_MOVE = 0
t.CMD_QUIT = 1

function t.print (str)
    print(str and str or '')
end

t.printError = t.print

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

    if code=='q' then
        return {code = t.CMD_QUIT}
    elseif code=='m' then
        local x = getToken()
        local y = getToken()
        local d = getToken()
        if not (x and y and d) then return nil end

        x = tonumber(x)
        y = tonumber(y)
        if not (x and y) then return nil end

        local from = Vector.newFromInput(x,y)
        local to = Vector.newFromInput(x,y)

            if d=='l' then to.x=to.x-1
        elseif d=='u' then to.y=to.y-1
        elseif d=='r' then to.x=to.x+1
        elseif d=='d' then to.y=to.y+1
        else return nil end

        return {code=t.CMD_MOVE, from=from, to=to}
    end

    return nil
end

return t
