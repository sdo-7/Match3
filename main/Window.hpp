#pragma once

class GLFWwindow;

class Window {
  GLFWwindow *wnd = nullptr;

public:
  Window () = default;
 ~Window ();
  //inline GLFWwindow *getWnd () { return this->wnd; }
  void create (int width, int height, const char *title);
  void makeCurrent ();
  bool getCloseFlag () const;
  void swapBuffers ();
} ;
