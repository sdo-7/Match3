#include <stdexcept>
#include "Impl.hpp"
#include "Thread.hpp"

Thread::Thread (Impl *impl)
: impl (impl) {
}

void Thread::launch () {
  if (iterationThread.joinable())
    throw std::runtime_error("Model thread is already created");
  colorsFlag.clear();

  const IterationThreadArgs args{
    colorsFlag,
    *this
  };
  iterationThread = std::thread(Thread::iterationThreadProc, args);
}

void Thread::tryUpdateColors () {
  if (colorsFlag.test())
    return;

  impl->lua.readColors(impl->data);
  impl->data.transferColorsToGPU();

  colorsFlag.test_and_set();
  colorsFlag.notify_all();
}

void Thread::iterationThreadProc (IterationThreadArgs args) {
  auto &colorsFlag = args.colorsFlag;
  auto &lua = args.t.impl->lua;

  for (;;) {
    colorsFlag.wait(false);

    lua.iterate();

    colorsFlag.clear();
    colorsFlag.notify_all();
  }
}
