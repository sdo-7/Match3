#include "Uniform.hpp"
#include "Model.hpp"
#include "View.hpp"

namespace {
  const char *vShaderCode = R"code(#version 330 core
    layout (location = 0) in vec4 inStartPos;
    layout (location = 1) in vec2 inSize;
    layout (location = 2) in vec4 inColor;
    uniform mat4 uProj;
    out Attributes {
      out vec4 color;
      out float radius;
      out vec4 center;
    } attrs;

    void main () {
      attrs.color = inColor;

      vec4 startPos = uProj * inStartPos;
      vec4 endPos = uProj * (inStartPos + vec4(inSize, 0, 0));
      vec4 size = endPos - startPos;
      vec4 center = startPos + size/2;
      float radius = min(abs(size.x), abs(size.y))/2;

      attrs.center = center;
      attrs.radius = radius;
    }
  )code";

  const char *gShaderCode = R"code(#version 330 core
    layout (points) in;
    layout (triangle_strip, max_vertices = 4) out;

    in Attributes {
      vec4 color;
      float radius;
      vec4 center;
    } attrs[];

    out vec4 fColor;
    out vec4 fPos;
    out float fRadius;

    void main () {
      fColor = attrs[0].color;
      fRadius = attrs[0].radius;

      fPos = vec4(-fRadius, fRadius, 0f, 0f);
      gl_Position = attrs[0].center + fPos;
      EmitVertex();

      fPos = vec4(fRadius, fRadius, 0f, 0f);
      gl_Position = attrs[0].center + fPos;
      EmitVertex();

      fPos = vec4(-fRadius, -fRadius, 0f, 0f);
      gl_Position = attrs[0].center + fPos;
      EmitVertex();

      fPos = vec4(fRadius, -fRadius, 0f, 0f);
      gl_Position = attrs[0].center + fPos;
      EmitVertex();

      EndPrimitive();
    }
  )code";

  const char *fShaderCode = R"code(#version 330 core
    in vec4 fColor;
    in vec4 fPos;
    in float fRadius;
    out vec4 outColor;

    void main () {
      float distance = sqrt(pow(fPos.x, 2) + pow(fPos.y, 2));
      if (distance > fRadius)
        discard;

      outColor = fColor;
    }
  )code";
}

View::~View () {
  setModel(nullptr);
}

void View::setModel (Model *model) {
  if (this->model == model)
    return;

  if (this->model) {
    const auto curModel = this->model;
    this->model = nullptr;
    curModel->setView(nullptr);
  }

  if (!model)
    return;

  this->model = model;
  model->setView(this);
}

void View::init () {
  program.make(vShaderCode, gShaderCode, fShaderCode);
}

void View::draw (glm::mat4 &proj) {
  model->update();

  program.use();
  auto uProj = program.getUniform("uProj");
  uProj.set<glm::mat4 &>(proj);

  auto vao = model->bindVAO();
  vao.drawArrays(GL_POINTS, 0, model->getLength());
}
