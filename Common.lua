local t = {}

function t.addROTable (t)
    return setmetatable({}, {__index = t, __newindex = function ()
        error("attempting to change a readonly table", 2)
    end})
end

return t
