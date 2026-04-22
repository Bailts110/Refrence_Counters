#define NOB_IMPLEMENTATION
#include "nob.h"

int main(int argc, char **argv) {
  GO_REBUILD_URSELF(argc, argv);
  Nob_Cmd cmd = {0};
  nob_cmd_append(&cmd, "clang", "-Wall", "-Wextra", "-Wswitch-enum", "-ggdb", "-o", "main","main.c");
   
  if (!nob_cmd_run(&cmd))
    return 1;
  nob_cmd_append(&cmd, "valgrind");
  nob_cmd_append(&cmd, "./main");
  if (!nob_cmd_run(&cmd))
    return 1;
  return 0;
}
