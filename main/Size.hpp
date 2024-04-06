#pragma once

template <typename T>
struct Size {
  T width;
  T height;

  constexpr Size () = default;
  constexpr Size (T width, T height)
  : width (width)
  , height (height) {
  }
} ;

template <typename T>
constexpr inline Size <T> operator / (Size <T> a, const Size <T> &b) {
  a.width /= b.width;
  a.height /= b.height;
  return a;
}

using Sizei = Size<int>;
