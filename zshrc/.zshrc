# Aliases
alias vim="nvim"

# Fast Node Manager installed via homebrew
eval "$(fnm env --use-on-cd --shell zsh)"
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Added by Windsurf
export PATH="/Users/ryan/.codeium/windsurf/bin:$PATH"

export PATH="$PATH:$HOME/.local/bin"

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ---- Starship ----
eval "$(starship init zsh)"
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ---- Yazi ----
export EDITOR="nvim"

function y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
            yazi "$@" --cwd-file="$tmp"
                IFS= read -r -d '' cwd < "$tmp"
                    [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
                        rm -f -- "$tmp"
                    }

# ---- Zoxide ----
eval "$(zoxide init zsh)"
