#pragma once

#include "GL.hpp"

class Shader {
protected:
  GLenum type = InvalidShaderType;
  ShaderID id = InvalidShaderID;
  const char *sourceCode = nullptr;

public:
  Shader () = default;
  Shader (const Shader &) = delete;
  Shader &operator = (const Shader &) = delete;
  Shader (Shader &&that) noexcept;
  Shader &operator = (Shader &&that) noexcept;
  void swap (Shader &that) noexcept;
  Shader (GLenum type);
  Shader (GLenum type, const char *sourceCode);
 ~Shader ();
  inline ShaderID getID () const { return id; }
  void compile ();
private:
  void assertCompilation ();
} ;

template <ShaderType Type>
class ShaderTemplate
: public Shader {
public:
  inline ShaderTemplate ()
  : Shader (Type) {
  }
  inline ShaderTemplate (const char *sourceCode)
  : Shader (Type, sourceCode) {
  }
} ;

using VShader = ShaderTemplate <GL_VERTEX_SHADER>;
using GShader = ShaderTemplate <GL_GEOMETRY_SHADER>;
using FShader = ShaderTemplate <GL_FRAGMENT_SHADER>;
