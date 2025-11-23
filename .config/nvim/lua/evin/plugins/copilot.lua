return {
  {
    "zbirenbaum/copilot.lua",
    event = "VeryLazy",
    config = function()
      vim.g.copilot_no_tab_map = true

      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          accept = false,
        },
        panel = { enabled = false },
        filetypes = {
          markdown = true,
          help = true,
          html = true,
          javascript = true,
          typescript = true,
          ["*"] = true,
        },
      })

      vim.keymap.set("i", "<S-Tab>", function()
        local suggestion = require("copilot.suggestion")
        if suggestion.is_visible() then
          suggestion.accept()
        else
          -- fallback Shift-Tab behavior (reverse indent)
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<S-Tab>", true, false, true), "n", false)
        end
      end, { silent = true })
    end,
  },
}
