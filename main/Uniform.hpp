#pragma once

#include "GL.hpp"

class Uniform {
  UniformLocation location = InvalidUniformLocation;

public:
  Uniform () = default;
  Uniform (UniformLocation location);
  template <typename T>
  void set (T value);
} ;
