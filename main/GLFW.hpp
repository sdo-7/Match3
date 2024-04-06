#pragma once

#include <stdexcept>
#include "toString.hpp"

class GLFWError
: public std::runtime_error {
public:
  template <typename... Types>
  GLFWError (Types... args)
  : std::runtime_error(toString(args...)) {
  }
} ;

class GLFW {
public:
  GLFW ();
 ~GLFW ();
  void pollEvents ();
} ;
