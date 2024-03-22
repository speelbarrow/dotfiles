-- `pip install "python-lsp-server[all]" mypy pylsp-mypy`
require "util.configure_lsp"("pylsp", "*.py", {
    settings = {
        pylsp = {
            plugins = {
                rope_autoimport = {
                    enabled = true
                },
                ruff = {
                    lineLength = 79
                },
            }
        }
    }
})
