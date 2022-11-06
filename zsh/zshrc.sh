# This file on the prompt are based off of the following dotfiles repository:
# https://github.com/Parth/dotfiles/tree/master/zsh
#
# Path to your oh-my-zsh configuration.
export ZSH_ROOT="$HOME/.dotfiles/zsh"
export ZSH="$ZSH_ROOT/modules/oh-my-zsh"

setopt inc_append_history # To save every command before it is executed 
setopt share_history      # setopt inc_append_history
setopt histignoredups

# Set to this to use case-sensitive completion
export CASE_SENSITIVE="true"
export DISABLE_AUTO_UPDATE="true"
export HIST_STAMPS="mm/dd/yyyy"

# Manually set the language environment we're running. In most
# cases this should default to a unicode font.
export LANG="en_US.UTF-8"

# Preferred editor for local and remote sessions
# Use vim as the default editor
export EDITOR="vim"

# Load all plugins and modules
source ~/.dotfiles/zsh/modules/oh-my-zsh/lib/history.zsh
source ~/.dotfiles/zsh/modules/oh-my-zsh/lib/key-bindings.zsh
source ~/.dotfiles/zsh/modules/oh-my-zsh/lib/completion.zsh
source ~/.dotfiles/zsh/modules/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.dotfiles/zsh/modules/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Fix for arrow-key searching
# start typing + [Up-Arrow] - fuzzy find history forward
if [[ "${terminfo[kcuu1]}" != "" ]]; then
	  autoload -U up-line-or-beginning-search
  	zle -N up-line-or-beginning-search
	  bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
fi

# start typing + [Down-Arrow] - fuzzy find history backward
if [[ "${terminfo[kcud1]}" != "" ]]; then
	  autoload -U down-line-or-beginning-search
	  zle -N down-line-or-beginning-search
	  bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
fi

# Export the manpages path on the local system
export MANPATH="/usr/local/man:$MANPATH"

# Path configuration
# All of the locations that should be added to the binary path for the users
HOMEBREW="${HOME}/.local/bin:${HOME}/bin:/usr/local/bin:/usr/local/sbin"

# Export the user binary path before any more execution
export PATH="${HOMEBREW}:/usr/bin:/bin:/usr/sbin:/sbin"

# Load the aliases and prompt changes last. We do this on purpose in case any
# module tries to make a change, we can override it.
source ~/.dotfiles/zsh/aliases.sh
source ~/.dotfiles/zsh/prompt.sh
source ~/.dotfiles/zsh/ssh-agent.sh

if [ -e "${HOME}/.zshrc.local" ]; then
  source ${HOME}/.zshrc.local
fi

