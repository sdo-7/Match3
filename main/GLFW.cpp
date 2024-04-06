#include <iostream>
#define GLAD_GL_IMPLEMENTATION
#include <glad/gl.h>
#include <GLFW/glfw3.h>
#include "GLFW.hpp"

namespace {
  void errorCallback (int error, const char *description) {
    std::cerr << "GLFW errorCallback: error 0x"
              << std::hex << error
              << "; description " << description
              << std::endl;
    std::terminate();
  }
}

GLFW::GLFW () {
  glfwSetErrorCallback(&errorCallback);

  if (!glfwInit())
    throw GLFWError("Couldn't create GLFW context");

  glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
  glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
  glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
}

GLFW::~GLFW () {
  glfwTerminate();
}

void GLFW::pollEvents () {
  glfwPollEvents();
}
