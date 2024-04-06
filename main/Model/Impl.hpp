#pragma once 

#include "Data.hpp"
#include "Lua.hpp"
#include "Thread.hpp"

class Impl {
public:
  Data data;
  Lua lua;
  Thread thread;

  Impl ();
} ;
