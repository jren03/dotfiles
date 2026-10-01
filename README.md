# dotfiles

Shared shell, tmux, vim, git, and WezTerm configs for the Mac and the lab servers.

```bash
git clone git@github.com:jren03/dotfiles.git ~/dotfiles
~/dotfiles/install_deps.sh            # install tools, then link configs
~/dotfiles/install_deps.sh --links-only
```

- **macOS:** installs Homebrew if missing, then the packages listed at the top of
  `install_deps.sh`; links tmux, vim, and WezTerm configs; adds one block to `~/.zshrc`
  that sources `src/zshrc`.
- **Lab servers (real0NN):** no sudo, so the tools go into a conda-forge prefix in
  `~/.local/opt/cli`, linked into `~/.local/bin`. `$HOME` is NFS, so one run covers every
  host. `~/.bashrc` (tracked by the bare `cfg` repo, branch `hosts/real003`) sources
  `src/.bash_aliases`.

The script is safe to rerun. It never overwrites a file that differs from the repo copy:
it stops and names the file, so you can merge your changes into `src/` first.

| File | Used by |
|---|---|
| `src/.bash_aliases` | bash on the servers and zsh on the Mac (keep it portable) |
| `src/zshrc` | Mac: history, fzf, zoxide, Homebrew PATH, WezTerm ssh tab titles |
| `src/tmux.conf` | `~/.config/tmux/tmux.conf` on both |
| `src/gitconfig` | included from `~/.gitconfig`: delta pager, zdiff3 conflicts |
| `src/.vimrc` | `~/.vimrc` on both |
| `src/wezterm.lua` | Mac: `~/.config/wezterm/wezterm.lua` |
