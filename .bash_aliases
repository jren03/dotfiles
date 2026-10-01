# Server-only aliases (lab servers). Shared aliases come from ~/dotfiles/src/.bash_aliases,
# which ~/.bashrc sources first; edit that file for anything the Mac should get too.

alias vbs='vim ~/.bash_aliases'

# Working directory
alias work='cd /store/real/renjt'

# Offline learning data study
alias data='conda activate data-dexmimicgen && cd /home/renjt/workspace/offline_learning_data_study/ && source set_env.sh'

# Claude Code accounts (isolated via CLAUDE_CONFIG_DIR; default `claude` uses ~/.claude)
alias claude-school='CLAUDE_CONFIG_DIR=/home/renjt/.claude-school command claude'

# Codex accounts (isolated via CODEX_HOME; default `codex` uses ~/.codex)
alias codex-school='CODEX_HOME=/home/renjt/.codex-school command codex'
