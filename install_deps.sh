#!/usr/bin/env bash
# Install the CLI tools and link the shared configs for this machine.
#
#   ./install_deps.sh               install packages, then link configs
#   ./install_deps.sh --links-only  link configs only
#
# Supported machines:
#   macOS                Homebrew (installed first if missing)
#   lab servers real0NN  no sudo: a conda-forge prefix in $HOME, which is NFS-shared,
#                        so one run covers every lab host
# Safe to rerun. It never overwrites a file that differs from the repo copy: it stops and
# says which file, so you can merge it into src/ first. Bash 3.2 compatible (macOS /bin/bash).
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$DOTFILES/src"

# The one package list. Columns: binary, Homebrew formula, conda-forge package ("-" = skip;
# the lab servers already have tmux).
PACKAGES="
fzf      fzf        fzf
zoxide   zoxide     zoxide
delta    git-delta  git-delta
lazygit  lazygit    lazygit
fd       fd         fd-find
bat      bat        bat
gh       gh         gh
tmux     tmux       -
"
LAB_PREFIX="$HOME/.local/opt/cli"       # conda prefix holding the tools on the lab servers
LAB_BIN="$HOME/.local/bin"              # on PATH via ~/.bashrc; tools are linked here
MAMBA="$HOME/miniforge3/bin/mamba"
ZSHRC_MARK="# >>> dotfiles (install_deps.sh) >>>"
WEZTERM_SH_URL="https://raw.githubusercontent.com/wez/wezterm/main/assets/shell-integration/wezterm.sh"

say() { echo "install_deps: $*"; }
die() { echo "install_deps: ERROR: $*" >&2; exit 1; }

packages_for() {  # column -> package names for that package manager
    echo "$PACKAGES" | awk -v c="$1" 'NF && $c != "-" { print $c }'
}
binaries_for() {  # column -> binaries that package manager provides
    echo "$PACKAGES" | awk -v c="$1" 'NF && $c != "-" { print $1 }'
}

link_file() {  # link_file <repo file> <target>: make <target> a symlink to <repo file>
    local src="$1" dst="$2" cur
    [ -e "$src" ] || die "missing $src"
    if [ -L "$dst" ]; then
        cur="$(readlink "$dst")"
        [ "$cur" = "$src" ] && return 0
        die "$dst links to $cur, not $src; repoint or remove it by hand"
    elif [ -e "$dst" ]; then
        if [ -s "$dst" ] && ! cmp -s "$src" "$dst"; then
            die "$dst differs from $src; merge what you want to keep into $src, then remove $dst"
        fi
        rm "$dst"  # empty, or identical to the repo copy: nothing is lost
    fi
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
    say "linked $dst -> $src"
}

remove_shadow() {  # remove_shadow <path> <repo file>: <path> would compete with the linked copy
    local path="$1" src="$2"
    [ -e "$path" ] || [ -L "$path" ] || return 0
    if { [ -L "$path" ] && [ "$(readlink "$path")" = "$src" ]; } || cmp -s "$path" "$src"; then
        rm "$path"
        say "removed $path (same as $src)"
    else
        die "$path differs from $src and would compete with it; merge it into $src, then remove it"
    fi
}

detect_machine() {
    case "$(uname -s)" in
        Darwin) echo mac ;;
        Linux)
            if [[ "$(hostname -s)" =~ ^real0[0-9][0-9]$ ]]; then
                echo lab
            else
                die "unsupported Linux host $(hostname -s); only the lab servers real0NN are set up"
            fi ;;
        *) die "unsupported OS $(uname -s)" ;;
    esac
}

brew_on_path() {
    command -v brew >/dev/null && return 0
    local b
    for b in /opt/homebrew/bin/brew /usr/local/bin/brew; do
        if [ -x "$b" ]; then eval "$("$b" shellenv)"; return 0; fi
    done
    return 1
}

install_mac() {
    if ! brew_on_path; then
        say "Homebrew not found; installing it (it asks for your password)"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        brew_on_path || die "Homebrew install did not produce a brew binary"
    fi
    # shellcheck disable=SC2046  # one formula per word
    brew install $(packages_for 2)
    if [ ! -f "$HOME/.config/wezterm/wezterm.sh" ]; then
        mkdir -p "$HOME/.config/wezterm"
        curl -fsSL "$WEZTERM_SH_URL" -o "$HOME/.config/wezterm/wezterm.sh"
        say "downloaded WezTerm shell integration"
    fi
}

install_lab() {
    [ -x "$MAMBA" ] || die "$MAMBA not found; the lab install uses miniforge in \$HOME"
    if [ -d "$LAB_PREFIX/conda-meta" ]; then
        # shellcheck disable=SC2046
        "$MAMBA" install -y -q -p "$LAB_PREFIX" -c conda-forge $(packages_for 3)
    else
        # shellcheck disable=SC2046
        "$MAMBA" create -y -q -p "$LAB_PREFIX" -c conda-forge $(packages_for 3)
    fi
    local b
    for b in $(binaries_for 3); do
        link_file "$LAB_PREFIX/bin/$b" "$LAB_BIN/$b"
    done
}

link_configs() {
    local machine="$1"
    link_file "$SRC/tmux.conf" "$HOME/.config/tmux/tmux.conf"
    link_file "$SRC/.vimrc" "$HOME/.vimrc"
    if ! git config --global --get-all include.path | grep -qxF "$SRC/gitconfig"; then
        git config --global --add include.path "$SRC/gitconfig"
        say "$HOME/.gitconfig now includes $SRC/gitconfig"
    fi
    if [ "$machine" = mac ]; then
        link_file "$SRC/wezterm.lua" "$HOME/.config/wezterm/wezterm.lua"
        remove_shadow "$HOME/.wezterm.lua" "$SRC/wezterm.lua"
        touch "$HOME/.zshrc"
        if ! grep -qF "$ZSHRC_MARK" "$HOME/.zshrc"; then
            # shellcheck disable=SC2016  # $DOTFILES is meant literally, expanded by zsh later
            printf '\n%s\nexport DOTFILES="%s"\nsource "$DOTFILES/src/zshrc"\n# <<< dotfiles <<<\n' \
                "$ZSHRC_MARK" "$DOTFILES" >> "$HOME/.zshrc"
            say "added the dotfiles block to ~/.zshrc"
        fi
        # Older hand-copied setup would now run twice; point at it rather than edit it.
        grep -nE 'bash_aliases|^ *ssh *\(\)' "$HOME/.zshrc" | grep -v 'DOTFILES' |
            sed 's/^/install_deps: NOTE: ~\/.zshrc duplicates src\/zshrc, remove line /' || true
    else
        [ "$DOTFILES" = "$HOME/dotfiles" ] || die "$HOME/.bashrc expects the repo at $HOME/dotfiles, not $DOTFILES"
        grep -qF 'dotfiles/src/.bash_aliases' "$HOME/.bashrc" ||
            die "$HOME/.bashrc does not source $SRC/.bash_aliases (it is tracked by the cfg repo)"
    fi
}

verify() {
    local col="$1" b missing=""
    for b in $(binaries_for "$col"); do
        if command -v "$b" >/dev/null; then
            say "ok      $b -> $(command -v "$b")"
        else
            missing="$missing $b"
        fi
    done
    [ -z "$missing" ] || die "not on PATH:$missing"
}

main() {
    local links_only=0
    case "${1:-}" in
        "") ;;
        --links-only) links_only=1 ;;
        -h|--help) sed -n '2,12p' "${BASH_SOURCE[0]}"; exit 0 ;;
        *) die "unknown argument $1 (try --help)" ;;
    esac
    local machine col
    machine="$(detect_machine)"
    if [ "$machine" = mac ]; then col=2; else col=3; fi
    say "machine: $machine ($(hostname -s)), repo: $DOTFILES"
    if [ "$links_only" = 0 ]; then
        "install_$machine"
    fi
    link_configs "$machine"
    if [ "$machine" = mac ]; then brew_on_path || true; fi
    verify "$col"
    say "done; open a new shell (or run: ub) to load the changes"
}

main "$@"
