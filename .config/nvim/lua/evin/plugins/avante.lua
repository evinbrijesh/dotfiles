return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,
    build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      or "make",
    opts = {
      -- This tells avante to use its built-in "copilot" provider,
      -- which will automatically use copilot.lua for authentication.
      provider = "copilot",

      -- You can still add other top-level options here
      instructions_file = "avante.md", -- optional
    },
    dependencies = {
      "zbirenbaum/copilot.lua", -- required for Copilot auth
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "hrsh7th/nvim-cmp",
      "nvim-tree/nvim-web-devicons",
      { "stevearc/dressing.nvim", optional = true },
      { "folke/snacks.nvim", optional = true },
      { "nvim-telescope/telescope.nvim", optional = true },
      { "ibhagwan/fzf-lua", optional = true },
      { "nvim-mini/mini.pick", optional = true },
    },
  },
}
