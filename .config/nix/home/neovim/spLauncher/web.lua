if vim.fs.root(0, { "package.json" }) ~= nil then
  vim.b.spLauncherActionMap = {
    base = "bun run",
    run = "start",
    build = true,
    test = true,
  }
end
