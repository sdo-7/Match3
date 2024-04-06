#include <stdexcept>
#include <filesystem>
#include "../toString.hpp"
#include "../Size.hpp"

class LuaError
: public std::runtime_error {
public:
  template <typename... Types>
  LuaError (Types... args)
  : std::runtime_error(toString(args...)) {
  }
} ;

struct lua_State;
class Data;

class Lua {
  lua_State *L = nullptr;

public:
  Lua () = default;
 ~Lua ();
  void createState ();
  void loadMain (const std::filesystem::path &luaDir);
  Sizei getFieldSize ();
  void iterate ();
  void readColors (Data &data);
private:
  void doFile (const char *fileName);
  int getGlobal (const char *name);
  int getGlobal (int type, const char *name);
  int getField (int index, const char *name);
  int getField (int type, int index, const char *name);
} ;
