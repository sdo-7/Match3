#pragma once

#include <atomic>
#include <thread>

class Impl;
struct IterationThreadArgs;

class Thread {
  Impl *impl = nullptr;
  std::atomic_flag colorsFlag;
  std::thread iterationThread;

public:
  Thread (Impl *impl);
  void launch ();
  void tryUpdateColors ();
private:
  static void iterationThreadProc (IterationThreadArgs args);
} ;

struct IterationThreadArgs {
  std::atomic_flag &colorsFlag;
  Thread &t;
} ;
