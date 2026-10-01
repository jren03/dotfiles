# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# --- Environment for EVERY shell: interactive, `ssh host 'cmd'`, and agent tool calls. ---
# Must stay above the interactivity guard below: non-interactive shells return there, so
# anything exported after it never reaches remote commands (that is how ~/.cache/uv and
# ~/.cache/torch filled up on NFS). /home is NFS shared by all hosts; caches and temp
# files go to per-host /local.
if [ -d "/local/real/$USER" ]; then
    export XDG_CACHE_HOME=/local/real/$USER/.cache
    export HF_HOME=$XDG_CACHE_HOME/huggingface
    export PIP_CACHE_DIR=$XDG_CACHE_HOME/pip
    export UV_CACHE_DIR=$XDG_CACHE_HOME/uv
    export npm_config_cache=$XDG_CACHE_HOME/npm   # npm ignores XDG_CACHE_HOME
    export TORCH_HOME=$XDG_CACHE_HOME/torch
    export TRITON_CACHE_DIR=$XDG_CACHE_HOME/triton
    export MPLCONFIGDIR=$XDG_CACHE_HOME/matplotlib
    export PYTHONPYCACHEPREFIX=$XDG_CACHE_HOME/pycache
    export NUMBA_CACHE_DIR=$XDG_CACHE_HOME/numba
    export CUDA_CACHE_PATH=$XDG_CACHE_HOME/cuda
    export TMPDIR=/local/real/$USER/tmp
    export WANDB_DIR=/local/real/$USER/wandb
    export WANDB_CACHE_DIR=$XDG_CACHE_HOME/wandb
    export WANDB_CONFIG_DIR=/local/real/$USER/wandb/config
    export WANDB_DATA_DIR=/local/real/$USER/wandb/data
    export WANDB_ARTIFACT_DIR=/local/real/$USER/wandb/artifacts
fi
export HYDRA_FULL_ERROR=1
case ":$PATH:" in   # guarded so re-sourcing does not keep prepending
    *":$HOME/.local/bin:"*) ;;
    *) export PATH="$HOME/local/node/node-v18.19.0-linux-x64/bin:$HOME/.npm-global/bin:$HOME/.local/bin:$HOME/bin:/home/real/bin:$PATH" ;;
esac

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
# Large history, appended after every command: many panes on many hosts share this
# NFS file, and the 1000-line default dropped commands across sessions.
HISTSIZE=100000
HISTFILESIZE=200000
HISTTIMEFORMAT='%F %T '
PROMPT_COMMAND="history -a${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like

# Shared aliases (same file the Mac zsh sources), then server-only ones.
if [ -f "$HOME/dotfiles/src/.bash_aliases" ]; then
    . "$HOME/dotfiles/src/.bash_aliases"
else
    echo "bashrc: $HOME/dotfiles/src/.bash_aliases missing; shared aliases not loaded" >&2
fi
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

##

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/renjt/miniforge3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/renjt/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/home/renjt/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/home/renjt/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

[ -f "$HOME/.secrets" ] && . "$HOME/.secrets"

# For backing up dotfiles
alias cfg="git --git-dir=$HOME/.cfg --work-tree=$HOME"

. "$HOME/.cargo/env"

# Fuzzy finder (Ctrl-R history, Ctrl-T files, Alt-C cd) and frecency cd (`z <part of path>`).
# Installed in /home/renjt/.local/opt/cli, linked into ~/.local/bin (NFS: every host).
for _tool in fzf zoxide; do
    command -v "$_tool" >/dev/null || echo "bashrc: $_tool not on PATH" >&2
done
unset _tool
command -v fzf >/dev/null && eval "$(fzf --bash)"
command -v zoxide >/dev/null && eval "$(zoxide init bash)"
