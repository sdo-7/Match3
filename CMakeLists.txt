cmake_minimum_required(VERSION 3.28)

project(
  Match3
  LANGUAGES CXX
)

set(APP_DIR "${PROJECT_SOURCE_DIR}")
configure_file(Config.h.in Config.h)

find_package(lua REQUIRED)
find_package(glfw3 REQUIRED)
find_package(glm REQUIRED)
find_package(OpenGL REQUIRED)
find_package(glad REQUIRED)

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
  PUBLIC "${CMAKE_CURRENT_BINARY_DIR}"
)
target_link_libraries(
  game
  lua::lua
  glfw
  glm::glm
  glad::glad
  opengl::opengl
)
set_property(TARGET game PROPERTY CXX_STANDARD 20)
set_property(TARGET game PROPERTY CXX_STANDARD_REQUIRED ON)
