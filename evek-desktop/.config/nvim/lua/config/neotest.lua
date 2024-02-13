local M = {}

function M.setup()
  require("neotest").setup {
    adapters = {
      require "neotest-python" {
        dap = { justMyCode = false },
        runner = "unittest",
      },
      require "neotest-jest",
      require "neotest-go",
      require "neotest-plenary",
      require "neotest-vim-test" {
        ignore_file_types = { "python", "vim", "lua" },
      },
      require("neotest-java")({
       -- function to determine which runner to use based on project path
       determine_runner = function(project_root_path)
           -- return should be "maven" or "gradle"
           return "gradle"
       end,
       -- override the builtin runner discovery behaviour to always use given
       -- tool. Default is "nil", so no override
       force_runner = nil,
       -- if the automatic runner discovery can't uniquely determine whether
       -- to use Gradle or Maven, fallback to using this runner. Default is
       -- "gradle"
       fallback_runner = "gradle"
    })
    },
  }
end

return M
