return function()
  return {
    exe = "clang-format",
    args = { '--style="{BasedOnStyle: llvm, ColumnLimit: 100, IndentWidth: 2, AccessModifierOffset: -2, PointerAlignment: Left}"' },
    stdin = true,
  }
end
