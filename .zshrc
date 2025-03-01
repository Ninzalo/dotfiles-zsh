# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

alias cls='clear'
alias act='source ./venv/bin/activate'
alias dea='deactivate'

export HOMEBREW_NO_ENV_HINTS=TRUE
export PATH="$HOME/.local/bin:/opt/homebrew/bin:$PATH"

function upd() {
  current_dir=$(pwd)
  echo "[INFO] Brew update started"
  brew update
  echo "[INFO] Brew upgrade started"
  brew upgrade
  echo "[INFO] Brew cleanup started"
  brew cleanup --prune=all
  echo "[INFO] Update finished"
  source ~/.zshrc
  echo "[INFO] Shell reloaded"
  cd $current_dir
}

# Zoxide (better cd)
source <(zoxide init zsh)

alias cd="z"

# Eza (better ls)
alias ll="eza -1lab --icons=always --group-directories-first --no-user --no-time --show-symlinks"

# Fzf
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# history setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# completion using arrow keys (based on history)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme

# Tmux auto start
# Check if tmux is installed
if command -v tmux > /dev/null 2>&1; then
    # Only proceed if not already inside a tmux session
    if [ -z "$TMUX" ]; then
        # Check if a tmux server is running
        if ! tmux ls > /dev/null 2>&1; then
            # No server running, start tmux
            tmux
        else
            # Server is running, attach to the first session
            first_session=$(tmux ls | head -n 1 | cut -d: -f1)
            tmux attach-session -t "$first_session"
        fi
    fi
fi
