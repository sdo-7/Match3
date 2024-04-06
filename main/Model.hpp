#pragma once

#include <filesystem>
#include "Model/Impl.hpp"

class View;

class Model {
  Impl impl;
  View *view = nullptr;

public:
  Model () = default;
  void setView (View *view);
  inline void setView (View &view) { setView(&view); }
  void init (Sizei windowSize, int padding, const std::filesystem::path &appDir);
  ArrayObject bindVAO ();
  inline int getLength () const { return impl.data.getLength(); }
  void launchThread ();
  void update ();
} ;
