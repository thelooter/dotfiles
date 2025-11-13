Purpose
This repository is a set of personal dotfiles managed by chezmoi. The source tree you see (under `~/.local/share/chezmoi`) is the canonical source for files deployed to a home directory. AI coding agents should treat this repo as configuration code: small, high‑impact edits require careful verification and an application step (`chezmoi`) before they take effect in the running environment.

**Big Picture**
- **Repo type**: chezmoi-managed dotfiles. Files that are intended to become dotfiles are often named with a `dot_` prefix (for example `dot_zshrc`, `nvim/dot_gitignore`, `dot_config/starship.toml`).
- **Major areas**: `dot_config/` (application configs: `nvim`, `awesome`, `polybar`, `btop`, `bat`, `starship`), `nvim/` / `nvim-lazy/` / `nvim-personal/` (Neovim config variants and lockfiles), and `private_k9s/` (private, sensitive config).
- **Why structured this way**: the tree separates shared templates (`nvim`, `nvim-lazy`) from personal overrides (`nvim-personal`). Lockfiles such as `lazy-lock.json` capture plugin versions; treat them as authoritative when present.

**Where to edit**
- Edit the source files in this repo (not the live files in `$HOME`) — e.g. change `dot_config/nvim/init.lua` or `dot_config/starship.toml` here, then apply with `chezmoi`.
- When adding new dotfiles, follow the `dot_` naming convention so chezmoi will manage them predictably (e.g. add `dot_foo` for `~/.foo`).
- Personal vs shared Neovim config: modify `dot_config/nvim/` for the shared base, and `dot_config/nvim-personal/` for user-specific overrides.

**Key commands / developer workflows**
- Preview changes that would be applied to the live system:
  - `chezmoi diff` — shows what would change in `$HOME`.
- Apply changes to your home environment:
  - `chezmoi apply` — applies current source tree to `$HOME`.
- Useful quick tests after editing configs:
  - Reload shell after `dot_zshrc` or `dot_config/starship.toml` changes: `exec zsh`.
  - Restart or respawn status bars using scripts in `dot_config/awesome/scripts/` (examples: `kill_polybar.sh`, `spawn_polybar.sh`).
  - For Neovim plugin changes: open Neovim and run Lazy's sync command (the repository contains `nvim-lazy`/`lazy-lock.json`): inside Neovim run `:Lazy sync` (or follow the `LazyVim` workflow documented in `dot_config/nvim-lazy/README.md`). Also run any repo-provided helper scripts such as `dot_config/nvim/executable_install.sh` to install language servers.

**Project-specific conventions & patterns**
- `dot_` prefix: source files that become dotfiles in `$HOME` use this prefix. Look for `dot_` files anywhere in the tree when searching for a target file to change.
- Multiple Neovim variants: there are three related dirs: `dot_config/nvim/` (base), `dot_config/nvim-lazy/` (LazyVim template), and `dot_config/nvim-personal/` (personal additions). When updating plugins or LSP scripts, pick the appropriate directory.
- Lockfiles: `lazy-lock.json` and `lazyvim.json` represent pinned plugin states. If you update plugin lists, expect to update and commit these lockfiles.
- Scripts for runtime changes: small shell scripts under `dot_config/awesome/scripts/` and similar directories are used to restart or spawn services; preferred testing is to call these script wrappers rather than manually killing processes.
- Private data: `private_k9s/` contains sensitive config — do not move secrets into other tracked files. Respect its intent.

**Integration points & external dependencies**
- Neovim plugin manager (LazyVim) and language servers: see `dot_config/nvim/lang-servers/` for language-specific installer scripts.
- System services and GUI: polybar, awesomeWM, starship prompt, and btop are configured here — changing their configs typically requires restarting the relevant process (see scripts in `dot_config/awesome/scripts/`).
- `chezmoi` is required to apply dotfile changes to the target system. Agents must not assume changes take effect until `chezmoi apply` (or a local manual link) is executed.

**Examples (concrete references)**
- Edit shell config: `dot_zshrc` → preview `chezmoi diff` → `chezmoi apply` → `exec zsh` to reload.
- Update Neovim LSPs: modify `dot_config/nvim/lua/plugins.lua` (or `nvim-personal/lua/plugins.lua`) → open Neovim and run `:Lazy sync` → run `dot_config/nvim/executable_install.sh` if present.
- Restart polybar (example scripts): `dot_config/awesome/scripts/kill_polybar.sh` then `dot_config/awesome/scripts/spawn_polybar.sh`.

**What not to do / safety checks**
- Do not commit secrets into non-private directories; `private_k9s/` exists specifically for private configs.
- Avoid making wide, automated changes across many `dot_` files without running `chezmoi diff` and testing in a safe environment.

If any section is unclear or you want more detail (for example: exact Neovim file locations to edit for plugins vs keymaps), tell me which area to expand and I will iterate.
