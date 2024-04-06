#include <algorithm>
#include <array>
#include "../GL.hpp"
#include "Data.hpp"

namespace {
  const std::array<ABGR, 7> colorsArray = {
    0xFF000000, // nil
    0xFF0000D5,
    0xFF53C800,
    0xFF00D6FF,
    0xFFEA0062,
    0xFFFE4F30,
    0xFFD4B800,
  };
}

void Data::createGLObjects () {
  vaos = std::move(ArrayObjects(1));
  vbos = std::move(BufferObjects(2));
}

void Data::createRAMBuffers (Sizei fieldSize, Sizei cellSize, int padding) {
  this->fieldSize = fieldSize;

  const auto length = fieldSize.width * fieldSize.height;
  points = std::vector<GLushort>(length * 4);
  colors = std::vector<GLuint>(length);

  initPointsRAMBuffer(cellSize, padding);
  initColorsRAMBuffer();
}

void Data::setValue (int x, int y, int value) {
  const auto offset = toOffset(x, y);
  colors[offset] = colorsArray[value];
}

void Data::transferPointsToGPU () {
  auto vao = bindVAO();
  auto vbo = vbos.bind(GL_ARRAY_BUFFER, 0);

  const auto sizeofPoints = points.size()*sizeof(GLushort);
  const auto pointsPtr = points.data();
  vbo.setData(sizeofPoints, pointsPtr, GL_STATIC_DRAW);
  vbo.setAttribute(0, 2, GL_UNSIGNED_SHORT, GL_FALSE, sizeof(GLushort)*4, 0);
  vbo.setAttribute(1, 2, GL_UNSIGNED_SHORT, GL_FALSE, sizeof(GLushort)*4, sizeof(GLushort)*2);
}

void Data::transferColorsToGPU () {
  auto vao = bindVAO();
  auto vbo = vbos.bind(GL_ARRAY_BUFFER, 1);

  const auto sizeOfColors = colors.size()*sizeof(GLuint);
  const auto colorsPtr = colors.data();
  vbo.setData(sizeOfColors, colorsPtr, GL_DYNAMIC_DRAW);
  vbo.setAttribute(2, 4, GL_UNSIGNED_BYTE, GL_TRUE, sizeof(GLuint)*1, 0);
}

ArrayObject Data::bindVAO () {
  return vaos.bind(0);
}

int Data::toOffset (int x, int y) const {
  const int offset = y*fieldSize.width + x;
  return offset;
}

void Data::initPointsRAMBuffer (Sizei cellSize, int padding) {
  const int innerCellWidth = cellSize.width - padding*2;
  const int innerCellHeight = cellSize.height - padding*2;

  for (int y = 0; y < fieldSize.height; ++y) {
    const int canvasY = y * cellSize.height + padding;
    for (int x = 0; x < fieldSize.width; ++x) {
      const int offset = toOffset(x, y)*4;
      const int canvasX = x * cellSize.width + padding;
      points[offset + 0] = canvasX;
      points[offset + 1] = canvasY;
      points[offset + 2] = innerCellWidth;
      points[offset + 3] = innerCellHeight;
    }
  }
}

void Data::initColorsRAMBuffer () {
  std::fill(colors.begin(), colors.end(), colorsArray[0]);
}
