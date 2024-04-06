#pragma once

#include "GL.hpp"

class Uniform;

class Program {
  const char *name = nullptr;
  ProgramID id = InvalidProgramID;

public:
  Program (const Program &) = delete;
  Program &operator = (const Program &) = delete;
  Program (const char *name = "");
 ~Program ();
  void make (const char *vShaderCode,
             const char *fShaderCode);
  void make (const char *vShaderCode,
             const char *gShaderCode,
             const char *fShaderCode);
  void use ();
  Uniform getUniform (UniformLocation location);
  Uniform getUniform (const char *name);
private:
  void assertLinkage ();
  void link ();
} ;
