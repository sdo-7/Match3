#include <stdexcept>
#include "BufferObjects.hpp"

BufferObject::BufferObject (BufferObject &&that) noexcept {
  swap(that);
}

BufferObject &BufferObject::operator = (BufferObject &&that) noexcept {
  swap(that);
  return *this;
}

void BufferObject::swap (BufferObject &that) noexcept {
  std::swap(target, that.target);
  std::swap(vbo, that.vbo);
  std::swap(prevVBO, that.prevVBO);
}

BufferObject::BufferObject (BufferTarget target, VBO vbo)
: target (target)
, vbo (vbo) {
  switch (target) {
  case GL_ARRAY_BUFFER:
    glGetIntegerv(GL_ARRAY_BUFFER_BINDING, (GLint*)&prevVBO);
    break;
  default:
    throw std::runtime_error("Unexpected buffer target");
  }
  glBindBuffer(target, vbo);
}

BufferObject::~BufferObject () {
  glBindBuffer(target, prevVBO);
}

void BufferObject::setData (GLsizeiptr size, const void *data, BufferUsage usage) {
  glBufferData(target, size, data, usage);
}

void BufferObject::setAttribute (GLuint location, GLint size, GLDataType type, GLboolean normalize, GLsizei stride, size_t offset) {
  glVertexAttribPointer(location, size, type, normalize, stride, (void*)(offset));
  glEnableVertexAttribArray(location);
}

BufferObjects::BufferObjects (BufferObjects &&that) noexcept {
  swap(that);
}

BufferObjects &BufferObjects::operator = (BufferObjects &&that) noexcept {
  swap(that);
  return *this;
}

void BufferObjects::swap (BufferObjects &that) noexcept {
  std::swap(vbos, that.vbos);
}

BufferObjects::BufferObjects (int count)
: vbos (count) {
  const auto buffers = vbos.data();
  glGenBuffers(count, buffers);
}

BufferObjects::~BufferObjects () {
  if (vbos.empty())
    return;

  const auto size = vbos.size();
  const auto buffers = vbos.data();
  glDeleteBuffers(size, buffers);
}

BufferObject BufferObjects::bind (BufferTarget target, int index) {
  const auto vbo = vbos.at(index);
  return BufferObject(target, vbo);
}
