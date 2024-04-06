#include <glad/gl.h>
#include <GLFW/glfw3.h>
#include "GLFW.hpp"
#include "Window.hpp"

Window::~Window () {
  glfwDestroyWindow(wnd);
}

void Window::create (int width, int height, const char *title) {
  wnd = glfwCreateWindow(width, height, title, nullptr, nullptr);

  if (!wnd)
    throw GLFWError("Couldn't create window '", title, "'");
}

void Window::makeCurrent () {
  glfwMakeContextCurrent(wnd);
  gladLoadGL(glfwGetProcAddress);
}

bool Window::getCloseFlag () const {
  const auto flag = glfwWindowShouldClose(wnd);
  return flag;
}

void Window::swapBuffers () {
  glfwSwapBuffers(wnd);
}
