#pragma once

#include <vector>
#include "GL.hpp"

class ArrayObject {
  VAO vao = InvalidVAO;
  VAO prevVAO = InvalidVAO;

public:
  ArrayObject () = default;
  ArrayObject (ArrayObject &&that) noexcept;
  ArrayObject &operator = (ArrayObject &&that) noexcept;
  void swap (ArrayObject &that) noexcept;
  ArrayObject (VAO vao);
 ~ArrayObject ();
  void drawArrays (DrawArraysMode mode, GLint first, GLsizei count);
} ;

class ArrayObjects {
  std::vector<VAO> vaos;

public:
  ArrayObjects () = default;
  ArrayObjects (const ArrayObjects &) = delete;
  ArrayObjects &operator = (const ArrayObjects &) = delete;
  ArrayObjects (ArrayObjects &&that) noexcept;
  ArrayObjects &operator = (ArrayObjects &&that) noexcept;
  void swap (ArrayObjects &that) noexcept;
  ArrayObjects (int count);
 ~ArrayObjects ();
  ArrayObject bind (int index);
} ;
