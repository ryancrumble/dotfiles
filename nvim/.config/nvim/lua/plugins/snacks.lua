return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      hidden = true,
      ignored = true,
      exclude = {
        "node_modules",
        ".git",
        "storybook-static",
        "dist",
        "build",
        "package-lock.json",
      },
      scroll = { enabled = false },
      sources = {
        explorer = {
          layout = {
            layout = {
              position = "right",
            },
          },
        },
      },
    },
  },
}
