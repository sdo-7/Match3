cmake_minimum_required(VERSION 3.28)

project(
  Match3
  LANGUAGES CXX
)

set(APP_DIR "${PROJECT_SOURCE_DIR}")
configure_file(Config.h.in Config.h)

add_subdirectory("libs/glfw")
add_subdirectory("libs/glm")
add_subdirectory("libs/lua")

aux_source_directory("main" gameSrc)
aux_source_directory("main/Model" gameSrc)
add_executable(
  game
  ${gameSrc}
)
target_compile_definitions(
  game
  PUBLIC GLFW_INCLUDE_NONE
)
target_include_directories(
  game
  PUBLIC "./libs"
  PUBLIC "./libs/glfw/include"
  PUBLIC "./libs/glfw/deps"
  PUBLIC "./libs/glm"
  PUBLIC "${CMAKE_CURRENT_BINARY_DIR}"
)
target_link_libraries(
  game
  glfw
  glm
  luaengine
)
set_property(TARGET game PROPERTY CXX_STANDARD 20)
set_property(TARGET game PROPERTY CXX_STANDARD_REQUIRED ON)
