
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Work around bug in browserify
ulimit -n 2560
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

source ~/.bashrc

# set up virtualenvwrapper for python3
export WORKON_HOMT=~/Envs
export VIRTUALENVWRAPPER_PYTHON=`which python3`
source /usr/local/bin/virtualenvwrapper.sh

# added by Anaconda3 4.3.1 installer
export PATH="/Users/ngarza10/anaconda/bin:$PATH"
export PATH="/usr/local/opt/libxml2/bin:$PATH"
export PATH="/usr/local/opt/libxml2/bin:$PATH"

export PATH="$HOME/.cargo/bin:$PATH"

eval "$(rbenv init -)"

# added by Anaconda3 5.2.0 installer
export PATH="/Users/ngarza10/anaconda3/bin:$PATH"

# Load rbenv automatically by appending
# the following to ~/.bash_profile:

eval "$(rbenv init -)"
