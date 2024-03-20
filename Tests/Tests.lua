local lu = require('luaunit')

testVector = dofile('./Tests/Vector.lua')
testModelFull = dofile('./Tests/Model.Full.lua')

os.exit(lu.LuaUnit.run())
