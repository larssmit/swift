// RUN: %target-swift-frontend %s -emit-ir -g -o - | FileCheck %s

func markUsed<T>(t: T) {}

class A {
  var a : A?
  // CHECK: define {{.*}}1AcfT_S0_
  init() {
    // This store that sets up the stack slot should be on line 0 so
    // the debugger may skip ahead.
    // CHECK:   store {{.*}} %0, {{.*}}, !dbg ![[DBG:[0-9]+]]
    // CHECK: ![[DBG]] = {{.*}}line: 0
    markUsed("Hi")
  }
}

let a = A()
