description: action: {
    __raw = ''function() 
      require 'lz.n'.trigger_load("dressing")
      local action = ${if action ? __raw then action.__raw else "'${action}'"}

      vim.ui.input(
        {
          prompt = ("You are about to execute the following action: '${description}'. " ..
                   "Are you sure you want to continue? [y/N]"),
        },
        function(input)
          if input and input:lower():sub(1, 1) == "y" then
            if type(action) == "string" then
              vim.cmd(action)
            else
              action()
            end
          end
        end
      )
    end'';
}
