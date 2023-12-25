local dispatch = require'setup.dispatch'

dispatch.configure_buffer {
    compiler = "arduino-cli --no-color compile",
    run = "-u",
    debug = dispatch.build_and_run(
        function()
            local yaml_path = require'lspconfig.util'.root_pattern("*.ino")(vim.fn.expand("%:p")).."/sketch.yaml"
            if vim.fn.filereadable(yaml_path) == 0 then
                vim.notify("Could not find `sketch.yaml` from which to read `default_port`", vim.log.levels.ERROR)
                return
            end
            local yaml = io.open(yaml_path, "r"):read("*a")
            local port = string.match(yaml, "default_port: ([^\n]+)")
            if port ~= nil then
                vim.cmd("Start arduino-cli monitor --no-color -p "..port)
            else
                vim.notify("Could not read `default_port`", vim.log.levels.ERROR)
            end
        end,
        "-u"
    ),
    build = "",
}
