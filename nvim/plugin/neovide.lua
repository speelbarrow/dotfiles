if vim.g.neovide then
    vim.o.guicursor = vim.o.guicursor .. ",i:-blinkwait350-blinkoff300-blinkon350"
    vim.o.guifont = "JetBrainsMono Nerd Font:h14"

    for key, value in pairs({
        underline_automatic_scaling = true,
        input_macos_alt_is_meta = true,
        fullscreen = true,
    })
    do
        vim.g["neovide_"..key] = value
    end

    for key, command in pairs({ c = "y", v = "p", x = "x" }) do
        vim.keymap.set({'n', 'i', 'v'}, "<D-"..key..">", "<Cmd>normal \"*"..command.."<CR>", { noremap = true })
    end
else
    vim.o.guicursor = vim.o.guicursor .. ",i:-blinkwait175-blinkoff150-blinkon175"
end
