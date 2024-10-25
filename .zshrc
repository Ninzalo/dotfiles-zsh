# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZSH_THEME="robbyrussell"

alias cls='clear'
alias ll='ls -al'
alias act='source ./venv/bin/activate'
alias dea='deactivate'

export HOMEBREW_NO_ENV_HINTS=TRUE
export PATH="$HOME/.local/bin:/opt/homebrew/bin:$PATH"

function upd() {
  current_dir=$(pwd)
  cd ~/dotfiles/nix-darwin/
  echo "[INFO] Nix update started"
  nix flake update
  echo "[INFO] Nix rebuild started"
  darwin-rebuild switch --flake .#mbp --impure
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

# Fzf
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)


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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

