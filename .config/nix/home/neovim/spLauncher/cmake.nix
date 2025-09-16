{ ... }: {
  base = "cmake -S . -B ./build";
  run.__raw = ''function()
    local fname = vim.fn.expand "%:t:r"
    return "&& cmake --build ./build && [ -f './build/" .. fname .. "' ] && ./build/" .. fname
  end'';
  debug.__raw = ''function()
    local fname = vim.fn.expand "%:t:r"
    return (
      "&& cmake --build ./build && [ -f './build/" .. 
      fname .. 
      "' ] && lldb ./build/" .. 
      fname
    )
  end'';
  build = "";
}
