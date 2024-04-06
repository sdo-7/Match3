#include "Shader.hpp"
#include "Uniform.hpp"
#include "Program.hpp"

Program::Program (const char *name)
: name (name) {
}

Program::~Program () {
  glDeleteProgram(id);
}

void Program::make (const char *vShaderCode,
                    const char *fShaderCode) {
  VShader vShader(vShaderCode);
  FShader fShader(fShaderCode);

  try {
    vShader.compile();
    fShader.compile();
  } catch (const GLError &e) {
    throw GLError("Program '", name, "': ", e.what());
  } catch (...) {
    throw GLError("Unexpected shader compilation error in program '", name, "'");
  }

  id = glCreateProgram();
  glAttachShader(id, vShader.getID());
  glAttachShader(id, fShader.getID());

  link();
}

void Program::make (const char *vShaderCode,
                    const char *gShaderCode,
                    const char *fShaderCode) {
  VShader vShader(vShaderCode);
  GShader gShader(gShaderCode);
  FShader fShader(fShaderCode);

  try {
    vShader.compile();
    gShader.compile();
    fShader.compile();
  } catch (const GLError &e) {
    throw GLError("Program '", name, "': ", e.what());
  } catch (...) {
    throw GLError("Unexpected shader compilation error in program '", name, "'");
  }

  id = glCreateProgram();
  glAttachShader(id, vShader.getID());
  glAttachShader(id, gShader.getID());
  glAttachShader(id, fShader.getID());

  try {
    link();
  } catch (...) {
    glDeleteProgram(id);
    throw;
  }
}

void Program::use () {
  glUseProgram(id);
}

Uniform Program::getUniform (UniformLocation location) {
  return Uniform(location);
}

Uniform Program::getUniform (const char *name) {
  const auto location = glGetUniformLocation(id, name);
  return getUniform(location);
}

void Program::assertLinkage () {
  int success;
  glGetProgramiv(id, GL_LINK_STATUS, &success);
  if (success)
    return;

  int logLength;
  glGetProgramiv(id, GL_INFO_LOG_LENGTH, &logLength);
  std::string log(logLength, '\0');
  glGetProgramInfoLog(id, logLength, nullptr, log.data());
  throw GLError("Couldn't link program '", name, "' (", log, ")");
}

void Program::link () {
  glLinkProgram(id);
  assertLinkage();
}
