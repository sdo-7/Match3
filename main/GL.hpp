#pragma once

#include <stdexcept>
#include <glad/glad.h>
#include "toString.hpp"

using ABGR = GLuint;

using VAO = GLuint;
constexpr VAO InvalidVAO = 0;

using VBO = GLuint;
constexpr VBO InvalidVBO = 0;

using DrawArraysMode = GLenum;
using BufferTarget = GLenum;
using GLDataType = GLenum;
using BufferUsage = GLenum;

using ShaderID = GLuint;
constexpr ShaderID InvalidShaderID = 0;
using ShaderType = GLenum;
constexpr ShaderType InvalidShaderType = -1;

using ProgramID = GLuint;
constexpr ProgramID InvalidProgramID = 0;

using UniformLocation = GLint;
constexpr UniformLocation InvalidUniformLocation = -1;

class GLError
: public std::runtime_error {
public:
  template <typename... Types>
  GLError (Types... args)
  : std::runtime_error (toString(args...)) {
  }
} ;
