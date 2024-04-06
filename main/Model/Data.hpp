#pragma once

#include <vector>
#include "../Size.hpp"
#include "../ArrayObjects.hpp"
#include "../BufferObjects.hpp"

class Data {
  std::vector<GLushort> points;
  std::vector<GLuint> colors;
  ArrayObjects vaos;
  BufferObjects vbos;
  Sizei fieldSize;

public:
  Data () = default;
  Data (const Data &) = delete;
  Data &operator = (const Data &) = delete;
  inline int getWidth () const { return fieldSize.width; }
  inline int getHeight () const { return fieldSize.height; }
  inline int getLength () const { return fieldSize.width * fieldSize.height; }
  void createGLObjects ();
  void createRAMBuffers (Sizei fieldSize, Sizei cellSize, int padding);
  void setValue (int x, int y, int value);
  void transferPointsToGPU ();
  void transferColorsToGPU ();
  ArrayObject bindVAO ();
private:
  int toOffset (int x, int y) const;
  void initPointsRAMBuffer (Sizei cellSize, int padding);
  void initColorsRAMBuffer ();
} ;
