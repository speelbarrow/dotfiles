# This file is gnored by `default.nix`'s glob import
''
    vim.b.spLauncherActionMap = {
      base = "pio",
      run = "run -t upload",
      build = "run",
      debug = true,
      test = true,
      clean = "run -t compiledb",
    }
''
