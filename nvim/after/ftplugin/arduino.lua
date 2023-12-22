local boards = {
    ["esp32:esp32:lolin32"] = 115200,
    ["teensy:avr:teensy41"] = 0,
}

local keys = {}
for k, _ in pairs(boards) do
    table.insert(keys, k)
end

if vim.fn.filereadable(vim.fn.expand("%:p:h").."/sketch.yaml") == 0 then
    vim.api.nvim_create_autocmd("UIEnter", {
        once = true,
        callback = function()
            require'telescope'.load_extension("ui-select")
            vim.ui.select(
                { "esp32:esp32:lolin32", "teensy:avr:teensy41" },
                {
                    prompt = "Sketch Bootstrap",
                },
                function (item, _)
                    if item ~= nil then
                        vim.fn.system(
                            "arduino-cli board attach -p /dev/cu.usbserial-0001 -b "..item.." "..vim.fn.expand("%"))
                        require'lspconfig'.arduino_language_server.setup(require'setup.lspconfig'.arduino)
                        vim.cmd.LspStart()
                    end
                end
            )
        end,
    })
end
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
