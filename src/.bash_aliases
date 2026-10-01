# shellcheck shell=bash
# Shared aliases and functions: sourced by bash on the lab servers and by zsh on the Mac.
# Keep this file portable (no bash-only or zsh-only syntax outside a version check).
# Server-only aliases live in ~/.bash_aliases on the servers (tracked by the `cfg` repo).
DOTFILES="${DOTFILES:-$HOME/dotfiles}"

# Prompt line (zsh only; bash keeps the prompt from ~/.bashrc)
if [ -n "$ZSH_VERSION" ]; then
    # shellcheck disable=SC2034  # read by zsh
    PROMPT='%B%F{blue}%d%f%b:~$ '
fi

# ---------------------------- Aliases ----------------------------
# Git Commands
alias gs='git status'
alias gp='git pull'
alias gb='git branch'
alias gd='git diff'
alias lg='lazygit'

# Conda
alias conc='conda create -n'
alias cr='conda env remove -n'
alias dc='conda deactivate'
alias cl='conda env list'

# Tmux: `t` attaches to session s1 or creates it; `t s2` does the same for s2.
# (The old `tr` alias shadowed the coreutils `tr` command.)
t() { tmux new -A -s "${1:-s1}"; }
alias tl='tmux ls'
alias tk='tmux kill-ses -t'
alias vt='vim ~/.config/tmux/tmux.conf'
alias ut='tmux source ~/.config/tmux/tmux.conf'

# Vim and Source
alias vb='vim "$DOTFILES/src/.bash_aliases"'
alias vv='vim ~/.vimrc'
alias vc='vim ~/.ssh/config'
if [ -n "$ZSH_VERSION" ]; then
    alias ub='source ~/.zshrc'
else
    alias ub='source ~/.bashrc'
fi

# Python
alias pu='pip install --upgrade pip'
alias pip='pip3'
alias sage-jn='sage -n jupyter'
alias python='python3'
alias py='python -m pdb -c c'

# General
alias hh='history | grep '
alias lw='ls -l | wc -l'
alias ls='ls --color=auto'
alias storage='du -hs * | sort -h'

# Miscellaneous
alias rs='rsync -azch --info=progress2'
alias tb='tensorboard --logdir'

# ---------------------------- Functions ----------------------------
cleanup_scripts() {
    # This function cleans all output under ./scripts/errs and ./scripts/outs
    # A separate base directory can also be provided using `cleanup_scripts new/base/path`
    local base_dir="${1:-scripts}"
    local dirs=("errs" "outs")

    for dir in "${dirs[@]}"; do
        local full_path="$base_dir/$dir"
            if [ -d "$full_path" ]; then
                echo "Cleaning $full_path"
                find "$full_path" -mindepth 1 -delete
            else
                echo "Creating $full_path"
                mkdir -p "$full_path"
            fi
    done
    echo "Scripts directories cleaned up successfully."
}
