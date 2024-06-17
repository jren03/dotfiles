# Prompt Line
PROMPT='%B%F{blue}%d%f%b:~$ '

# Git Commands
alias gs='git status'
alias gp='git pull'
alias gb='git branch'

# Conda
alias conc='conda create -n'
alias dc='conda deactivate'
alias cr='conda env remove -n'
alias cl='conda env list'

# Tmux
alias tl='tmux ls'
alias tn='tmux new -s s1'
alias tr='tmux a -t s1'
alias tk='tmux kill-ses -t s1'
alias tn2='tmux new -s s2'
alias tr2='tmux a -t s2'
alias tk2='tmux kill-ses -t s2'
alias vt='vim ~/.config/tmux/tmux.conf'
alias ut='tmux source ~/.config/tmux/tmux.conf'

# Vim and Source
alias vb='vim ~/.bashrc'
alias ub='source ~/.bashrc'
alias vv='vim ~/.vimrc'
alias uv='source ~/.vimrc'
alias vc='vim ~/.ssh/config'
alias uc='source ~/.ssh/config'

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
