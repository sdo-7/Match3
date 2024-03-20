rockspec_format = "3.0"
package = "match3"
version = "dev-1"
source = {
   url = "git+ssh://git@github.com/sdo-7/Match3.git"
}
test_dependencies = {
   "luaunit"
}
build = {
   type = "builtin",
   modules = {
      Position = "Position.lua",
      Vector = "Vector.lua",
      Console = "Console.lua",
      Main = "Main.lua",
      Model = "Model.lua",
      View = "View.lua"
   },
   copy_directories = {
      "tests"
   }
}
test = {
   type = "command",
   command = "lua ./Tests/Tests.lua"
}
