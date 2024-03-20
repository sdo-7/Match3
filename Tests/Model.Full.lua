local lu = require('luaunit')

local Model = require('Model')

local t = {}

function t:test ()
  local model = Model.new(10, 10)

  math.randomseed(0)
  model:init()

  model:move({x=8, y=4}, {x=9, y=4})

  local sample = {
    2, 1, 4, 6, 5, 1, 1, 6, 3, 3,
    2, 4, 4, 6, 2, 5, 5, 3, 1, 4,
    1, 6, 5, 4, 3, 2, 5, 3, 1, 4,
    1, 6, 4, 1, 4, 3, 6, 3, 1, 2,
    3, 2, 4, 3, 2, 3, 6, 5, 5, 2,
    5, 3, 6, 6, 5, 5, 4, 6, 6, 5,
    5, 3, 4, 3, 1, 3, 3, 6, 1, 1,
    6, 5, 2, 4, 6, 3, 5, 5, 4, 4,
    2, 4, 4, 5, 1, 6, 1, 6, 2, 1,
    3, 5, 4, 1, 5, 2, 4, 6, 2, 5
  }
  sample.height = 10
  sample.width = 10

  lu.assertItemsEquals(model._impl.field, sample)
end

return t
