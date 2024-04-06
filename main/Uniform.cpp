#include <glm/gtc/type_ptr.hpp>
#include "Uniform.hpp"

Uniform::Uniform (UniformLocation location)
: location (location) {
}

template <>
void Uniform::set <glm::mat3 &> (glm::mat3 &value) {
  glUniformMatrix3fv(location, 1, GL_FALSE, glm::value_ptr(value));
}

template <>
void Uniform::set <glm::mat4 &> (glm::mat4 &value) {
  glUniformMatrix4fv(location, 1, GL_FALSE, glm::value_ptr(value));
}
