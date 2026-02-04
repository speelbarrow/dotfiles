{ ... }: {
  base.__raw = ''if vim.bo.filetype == "cpp" then "clang++" else "clang" end'';
  run.__raw = ''function()
    local temp = vim.fn.tempname()
    return "-o " .. temp .. " % && " .. temp
  end'';
  debug = {
    handler.__raw = ''function()
      local temp = vim.fn.tempname()
      return "-g -o " .. temp .. " % && lldb " .. temp
    end'';
    config = {
      window = {
        focus = "insert";
        persist = false;
      };
    };
  };
  build = "%";
  __raw = ''
    if vim.fs.root(0, { 'CMakeLists.txt' }) ~= nil then
      vim.b.spLauncherActionMap = {
        base = "cmake -S . -B ./build",
        run = function()
          local fname = vim.fn.expand "%:t:r"
          return "&& cmake --build ./build && [ -f './build/" .. fname .. "' ] && ./build/" .. fname
        end,
        debug = function()
          local fname = vim.fn.expand "%:t:r"
          return (
            "&& cmake --build ./build && [ -f './build/" .. 
            fname .. 
            "' ] && lldb ./build/" .. 
            fname
          )
        end,
        build = "",
      }
    elseif vim.fs.root(0, { 'Makefile' }) ~= nil then
      vim.b.spLauncherActionMap = {
        base = "make",
        run = " run",
        build = "",
      }
    elseif vim.fs.root(0, { 'platformio.ini' }) ~= nil then
      ${import ./platformio.nix}
    end
  '';
}
