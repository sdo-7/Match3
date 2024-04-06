#include "ArrayObjects.hpp"

ArrayObject::ArrayObject (ArrayObject &&that) noexcept {
  swap(that);
}

ArrayObject &ArrayObject::operator = (ArrayObject &&that) noexcept {
  swap(that);
  return *this;
}

void ArrayObject::swap (ArrayObject &that) noexcept {
  std::swap(vao, that.vao);
  std::swap(prevVAO, that.prevVAO);
}

ArrayObject::ArrayObject (VAO vao)
: vao (vao) {
  glGetIntegerv(GL_VERTEX_ARRAY_BINDING, (GLint*)&prevVAO);
  glBindVertexArray(vao);
}

ArrayObject::~ArrayObject () {
  // TODO move restoring from objects into separate restore guards
  glBindVertexArray(prevVAO);
}

void ArrayObject::drawArrays (DrawArraysMode mode, GLint first, GLsizei count) {
  glDrawArrays(mode, first, count);
}

ArrayObjects::ArrayObjects (ArrayObjects &&that) noexcept {
  swap(that);
}

ArrayObjects &ArrayObjects::operator = (ArrayObjects &&that) noexcept {
  swap(that);
  return *this;
}

void ArrayObjects::swap (ArrayObjects &that) noexcept {
  std::swap(vaos, that.vaos);
}

ArrayObjects::ArrayObjects (int count)
: vaos (count) {
  const auto arrays = vaos.data();
  glGenVertexArrays(count, arrays);
}

ArrayObjects::~ArrayObjects () {
  if (vaos.empty())
    return;

  const auto size = vaos.size();
  const auto arrays = vaos.data();
  glDeleteVertexArrays(size, arrays);
}

ArrayObject ArrayObjects::bind (int index) {
  const auto vao = vaos.at(index);
  return ArrayObject(vao);
}
