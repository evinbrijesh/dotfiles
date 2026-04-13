# Dotfiles
Personal Linux workstation config. Keeps shell, editor, multiplexer, compositor, and AI tooling consistent across machines.

**Platform:** Linux — Wayland/Hyprland, Linuxbrew paths assumed.

---

## What's in here

```text
.
├── .zshrc                  # Entry point — loads p10k, sources zsh/rc
├── zsh/                    # Modular zsh config
│   ├── rc                  # Load orchestrator
│   ├── options             # History, completion, keybindings
│   ├── envs                # EDITOR, PATH additions, tool vars
│   ├── init                # Plugin sourcing, tool hooks (mise, zoxide, fzf...)
│   ├── aliases             # eza, fzf, git shorthands, Hypr/Omarchy helpers
│   └── functions           # yazi cwd handoff, scp picker, omarchy fns
│
├── .tmux.conf              # tmux config — prefix, splits, copy mode, TPM plugins
├── .tmux/                  # Vendored TPM clone [not curated]
│
├── .config/
│   ├── nvim/               # Neovim — lazy.nvim, LSP, treesitter, AI (avante, copilot)
│   ├── hypr/               # Hyprland — env vars, dual-monitor layout
│   └── opencode/           # Opencode AI tool — provider config, custom agents
│
└── Modelfiles/             # Ollama model definitions (qwen3.5-coding, gemma4-coding)
```

---

## Layers

**Zsh** — modular rc split into `options`, `envs`, `init`, `aliases`, `functions`. Powerlevel10k with instant prompt. Plugins via Linuxbrew: autosuggestions, syntax-highlighting, zoxide, fzf.

**tmux** — `C-a` prefix, vim-style pane navigation/resizing, vi-like copy mode (`v`/`y`), Tokyo Night theme, and session persistence via resurrect + continuum.

**Neovim** — `lua/evin/` namespace. `lazy.nvim` plugin manager. Full LSP stack via Mason (web/Python/Lua). Formatting with `conform.nvim`, linting with `nvim-lint`. AI via `avante.nvim` + `copilot.lua`. Tokyonight theme with transparency.

**Hyprland** — Wayland-first env vars, dual-monitor config (HDMI 1080p@120 + laptop eDP 1080p@60 scaled). Commented blocks for alternate layouts.

**Opencode** — local Ollama endpoint (`qwen3.5`), permissive read + cautious write shell policy. Nine custom agent roles/prompts: `architect`, `engineer`, `reviewer`, `debugger`, `docs`, `stack-picker`, `sec-auditor`, `log-tracer`, `test-writer`.

**Modelfiles** — Ollama model definitions tuned for coding: low temperature, 32K context, security/correctness-focused system prompts.

---

## Notes

- `.tmux/` and `.config/opencode/node_modules/` are vendored/generated — not curated config.
- Several paths reference [Omarchy](https://github.com/basecamp/omarchy) runtime (`~/.local/share/omarchy/`), which lives outside this repo.
- Absolute paths like `/home/e0kt/` appear in a few places and may need updates per machine.
- `.config/nvim/README.md` is a placeholder from the upstream LazyVim template.
