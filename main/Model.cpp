#include "View.hpp"
#include "Model.hpp"

void Model::setView (View *view) {
  if (this->view == view)
    return;

  if (this->view) {
    const auto curView = this->view;
    this->view = nullptr;
    curView->setModel(nullptr);
  }

  if (!view)
    return;

  this->view = view;
  view->setModel(this);
}

void Model::init (Sizei windowSize, int padding, const std::filesystem::path &appDir) {
  impl.data.createGLObjects();
  impl.lua.createState();
  impl.lua.loadMain(appDir / "lua");

  const auto fieldSize = impl.lua.getFieldSize();
  const auto cellSize = windowSize / fieldSize;
  impl.data.createRAMBuffers(fieldSize, cellSize, padding);
  impl.data.transferPointsToGPU();
  impl.data.transferColorsToGPU();
}

ArrayObject Model::bindVAO () {
  return impl.data.bindVAO();
}

void Model::launchThread () {
  impl.thread.launch();
}

void Model::update () {
  impl.thread.tryUpdateColors();
}
