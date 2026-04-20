# This file is gnored by `default.nix`'s glob import
''
    vim.b.spLauncherActionMap = {
      base = "pio",
      run = "run -t upload -t monitor",
      build = "run",
      debug = true,
      test = "test -v", -- `-v` required or program output won't be displayed
      clean = "run -t clean",
      Clean = "run -t compiledb",
    }
''
