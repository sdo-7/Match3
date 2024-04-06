#pragma once

#include <glm/mat4x4.hpp>
#include "Program.hpp"

class Model;

class View {
  Model *model = nullptr;
  Program program = Program("ViewProgram");

public:
  View () = default;
 ~View ();
  View (const View &) = delete;
  View &operator = (const View &) = delete;
  void setModel (Model *model);
  inline void setModel (Model &model) { setModel(&model); }
  void init ();
  void draw (glm::mat4 &proj);
} ;
