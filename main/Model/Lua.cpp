#include <filesystem>
#include <ostream>
#include <lua.hpp>
#include "Data.hpp"
#include "Lua.hpp"

namespace {
  class StackGuard {
    lua_State *L;

  public:
    StackGuard (lua_State *L)
    : L (L) {
    }
    ~StackGuard () {
      lua_settop(L, 0);
    }
  } ;

  namespace fs = std::filesystem;
  class PathGuard {
    const fs::path origPath;

  public:
    PathGuard (const fs::path newPath)
    : origPath (std::filesystem::current_path()) {
      fs::current_path(newPath);
    }

    ~PathGuard () {
      fs::current_path(origPath);
    }
  } ;
}

Lua::~Lua () {
  lua_close(L);
}

void Lua::createState () {
  L = luaL_newstate();
  if (!L)
    throw LuaError("Couldn't create Lua state");
  luaL_openlibs(L);
}

void Lua::loadMain (const std::filesystem::path &luaDir) {
  PathGuard pg(luaDir);

  doFile("./Main.lua");
}

Sizei Lua::getFieldSize () {
  StackGuard sg(L);

  getGlobal(LUA_TTABLE, "model");
  getField(LUA_TTABLE, -1, "_impl");
  getField(LUA_TTABLE, -1, "field");
  getField(LUA_TNUMBER, -1, "width");
  getField(LUA_TNUMBER, -2, "height");

  const int width = lua_tointeger(L, -2);
  const int height = lua_tointeger(L, -1);

  return {width, height};
}

void Lua::iterate () {
  getGlobal(LUA_TFUNCTION, "iterate");
  lua_call(L, 0, 0);
}

void Lua::readColors (Data &data) {
  StackGuard sg(L);

  getGlobal(LUA_TTABLE, "model");
  getField(LUA_TTABLE, -1, "_impl");
  getField(LUA_TTABLE, -1, "field");

  for (int y = 0; y < data.getHeight(); ++y) {
    for (int x = 0; x < data.getWidth(); ++x) {
      getField(LUA_TFUNCTION, -1, "get");
      lua_pushvalue(L, -2);
      lua_pushinteger(L, x+1);
      lua_pushinteger(L, y+1);
      lua_call(L, 3, 1);

      int value = 0;
      switch (lua_type(L, -1)) {
      case LUA_TNIL:
        break;
      case LUA_TNUMBER:
        value = lua_tointeger(L, -1);
        break;
      default:
        throw LuaError("Unexpected type from field:get");
      }
      lua_pop(L, 1);

      data.setValue(x, y, value);
    }
  }
}

void Lua::doFile (const char *fileName) {
  const auto res = luaL_dofile(L, fileName);
  if (res != LUA_OK) {
    const auto msg = lua_tostring(L, -1);
    throw LuaError("Couldn't open file '", fileName, "' (", msg, ")");
  }
}

int Lua::getGlobal (const char *name) {
  const auto type = lua_getglobal(L, name);
  if (type == LUA_TNONE)
    throw LuaError("Couldn't open global field '", name, "'");
  return type;
}

int Lua::getGlobal (int type, const char *name) {
  const int actualType = getGlobal(name);
  if (type != actualType)
    throw LuaError("Unexpected type of global field '", name, "'");
  return type;
}

int Lua::getField (int index, const char *name) {
  const auto type = lua_getfield(L, index, name);
  if (type == LUA_TNONE)
    throw LuaError("Couldn't open field '", name, "'");
  return type;
}

int Lua::getField (int type, int index, const char *name) {
  const int actualType = getField(index, name);
  if (type != actualType)
    throw LuaError("Unexpected type of field '", name, "'");
  return type;
}
