# This file should act as a stand-in on a server. Everything should be automatically
# routed through TMUX in server environments. This will always call git update on the
# dotfiles repository and ensure we're always updated to the latest.

export DOTFILE_ROOT="${HOME}/.dotfiles"
export ZSH_ROOT="${DOTFILE_ROOT}/zsh"

echo "Running ZSH manager"

# Run tmux if exists
if command -v tmux>/dev/null; then
  	[ -z $TMUX ] && exec tmux
else 
	  echo "tmux not installed. Please configure dependencies first."
fi

echo "Updating ZSH configuration"
(cd ${DOTFILE_ROOT} && git pull && git submodule update --init --recursive)

echo "Starting ZSH configuration"
source ${ZSH_ROOT}/zshrc.sh
