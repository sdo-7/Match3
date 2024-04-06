cmake_minimum_required(VERSION 3.28)

project(
  luaengine
  LANGUAGES C
)

aux_source_directory("." luaengineSrc)
add_library(
  luaengine
  STATIC
  ${luaengineSrc}
)
