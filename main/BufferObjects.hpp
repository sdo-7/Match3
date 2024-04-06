#pragma once

#include <vector>
#include "GL.hpp"

class BufferObject {
  BufferTarget target;
  VBO vbo = InvalidVBO;
  VBO prevVBO = InvalidVBO;

public:
  BufferObject () = default;
  BufferObject (const BufferObject &) = delete;
  BufferObject &operator = (const BufferObject &) = delete;
  BufferObject (BufferObject &&that) noexcept;
  BufferObject &operator = (BufferObject &&that) noexcept;
  void swap (BufferObject &that) noexcept;
  BufferObject (BufferTarget target, VBO vbo);
 ~BufferObject ();
  void setData (GLsizeiptr size, const void *data, BufferUsage usage);
  void setAttribute (GLuint location, GLint size, GLDataType type, GLboolean normalize, GLsizei stride, size_t offset);
} ;

class BufferObjects {
  std::vector <VBO> vbos;

public:
  BufferObjects () = default;
  BufferObjects (const BufferObjects &) = delete;
  BufferObjects &operator = (const BufferObjects &) = delete;
  BufferObjects (BufferObjects &&that) noexcept;
  BufferObjects &operator = (BufferObjects &&that) noexcept;
  void swap (BufferObjects &that) noexcept;
  BufferObjects (int count);
 ~BufferObjects ();
  BufferObject bind (BufferTarget target, int index);
} ;
