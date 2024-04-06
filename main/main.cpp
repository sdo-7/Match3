#include <iostream>
#include <filesystem>
#include <glm/mat4x4.hpp>
#include <glm/ext/matrix_clip_space.hpp>
#include <Config.h>
#include "GLFW.hpp"
#include "Window.hpp"
#include "Model.hpp"
#include "View.hpp"

void assertGlError (const char *msg) {
  const auto error = glGetError();

  if (error == GL_NO_ERROR)
    return;

  throw std::runtime_error(msg);
}

int main (int argc, char *argv[]) {
  constexpr Sizei windowSize{400, 400};
  Model model; // FIXME handle destruction of std::thread

  try {
    GLFW glfw;
    Window wnd;
    wnd.create(windowSize.width, windowSize.height, "Match3");
    wnd.makeCurrent();

    View view;
    view.init();

    //Model model;
    model.init(windowSize, 2, std::filesystem::path(APP_DIR));
    model.launchThread();
    model.setView(view);

    glm::mat4 proj = glm::ortho<float>(0, windowSize.width, windowSize.height, 0);

    // FIXME handle destruction of std::thread from Model
    //while (!wnd.getCloseFlag()) {
    for (;;) {
      glClearColor(33.0/255, 33.0/255, 33.0/255, 1);
      glClear(GL_COLOR_BUFFER_BIT);

      view.draw(proj);

      wnd.swapBuffers();
      glfw.pollEvents();
    }

    return 0;
  } catch (const GLError &e) {
    std::cerr << "GLError: " << e.what() << std::endl;
  } catch (const LuaError &e) {
    std::cerr << "LuaError: " << e.what() << std::endl;
  } catch (const std::exception &e) {
    std::cerr << "Error: " << e.what() << std::endl;
  } catch (...) {
    std::cerr << "Unknown error" << std::endl;
  }

  return -1;
}
