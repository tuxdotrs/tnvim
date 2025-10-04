local servers = { "eslint", "gopls", "templ", "pyright", "ruff", "svelte", "tailwindcss", "nil_ls", "html", "htmx" }

vim.lsp.config("nil_ls", {
  filetypes = { "nix" },
  settings = {
    ["nil"] = {
      flake = {
        autoArchive = true,
      },
    },
  },
})

vim.lsp.config("html", {
  filetypes = { "html", "templ" },
})

vim.lsp.config("htmx", {
  filetypes = { "html", "templ" },
})

vim.lsp.enable(servers)
