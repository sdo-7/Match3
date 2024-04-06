#include <map>
#include "Shader.hpp"

namespace {
  const char *toName (ShaderType type) {
    static std::map <ShaderType, const char *> names = {
      {GL_VERTEX_SHADER, "VertexShader"},
      {GL_GEOMETRY_SHADER, "GeometryShader"},
      {GL_FRAGMENT_SHADER, "FragmentShader"},
    };

    const auto name = names.contains(type) ? names.at(type) : "UnexpectedShaderType";
    return name;
  }
}

Shader::Shader (GLenum type)
: type (type) {
}

Shader::Shader (Shader &&that) noexcept {
  swap(that);
}

Shader &Shader::operator = (Shader &&that) noexcept {
  swap(that);
  return *this;
}

void Shader::swap (Shader &that) noexcept {
  std::swap(type, that.type);
  std::swap(id, that.id);
  std::swap(sourceCode, that.sourceCode);
}

Shader::Shader (GLenum type, const char *sourceCode)
: type (type)
, sourceCode (sourceCode) {
}

Shader::~Shader () {
  glDeleteShader(id);
}

void Shader::compile () {
  id = glCreateShader(type);
  glShaderSource(id, 1, &sourceCode, nullptr);
  glCompileShader(id);
  assertCompilation();
}

void Shader::assertCompilation () {
  int success;
  glGetShaderiv(id, GL_COMPILE_STATUS, &success);
  if (success == GL_TRUE)
    return;
  
  if (success == 0xCCCCCCCC)
    throw GLError("Couldn't compile shader. All is bad");

  int logLength;
  glGetShaderiv(id, GL_INFO_LOG_LENGTH, &logLength);
  std::string log(logLength, '\0');
  glGetShaderInfoLog(id, logLength, nullptr, log.data());
  throw GLError("Couldn't compile shader ", toName(type), " (", log, ")");
}
