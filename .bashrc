#!/usr/bin/env bash

# standard file aliases
alias site="cd ~/Sites"
alias docs="cd ~/Documents"
alias down="cd ~/Downloads"
alias pix="cd ~/Picutres"
alias desk="cd ~/Desktop"
alias rail="site; cd ./rails"
alias bcon="rail; cd ./bconnected"
alias usaa="bcon; cd ./svn-usaa"
alias umed="usaa; cd ./branches/release_2014_Q3_medicare"
alias udent="usaa; cd ./branches/release_20140609_dental_phase3"
alias learn="site; cd ./learn"
alias movie="cd ~/Movies"

#usaa
alias umedrs="umed; rails s"
alias udentrs="udent; rails s"
alias umedrc="umed; rails c"
alias udentrc="udent; rails c"

# Aliases for common tasks

alias l="ls -la"
alias ll="ls -l"
alias la="ls -a"

alias cthulhu="diskutil unmount"
alias switch="set -o" # enter vi or emacs after

# aliases for git

alias gs="git status "
alias ga="git add "
alias gb="git branch "
alias gc="git commit"
alias gd="git diff"
# alias go="git checkout "
alias gk="gitk --all&"
alias gitx="open -a GitX ."
alias gx="gitx"

alias got="git "
alias get="git "

# aliases for Postgresql
alias postgresql.server='function pgsql_server() { case $1 in "start") echo "Trying to start PostgreSQL..."; pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start ;; "stop") echo "Trying to stop PostgreSQL..."; pg_ctl -D /usr/local/var/postgres stop -s -m fast ;; esac }; pgsql_server'

alias pg-start='brew services start postgresql'
alias pg-stop='brew services stop postgresql'
# Dev junk

alias clog="tail -f #{ARGV[0]} | ruby -p -rYAML -e '$_.gsub!(/(?<=Parameters:)
(.+)/) { $1 + \"\n=====\n\" + YAML.dump(eval($1)) }'"

# path manipulation...

# ---------------------------------------------------------------------
# SHELL SETTINGS
# ---------------------------------------------------------------------

# Set a sane umask.
umask u=rwx,g=rwx,o=rx

# Use vi mode for command-line editing.
set -o vi

# Allow screen refresh in vi-insert mode.
# bind -m vi-insert "\C-l":clear-screen

# Expand ! history commands by typing a space after them.
bind Space:magic-space

# Don't overwrite files with redirects.
set -o noclobber

# Assume non-directory args to cd are variables to expand.
shopt -s cdable_vars

# Correct spelling errors in cd args.
shopt -s cdspell

# Check hash for command paths.
shopt -s checkhash

# make sure that LINES and COLUMNS are correct after every command.
shopt -s checkwinsize

# Smush multi-line commands into one history entry.
shopt -s cmdhist

# Include "." files in path expansion.
shopt -s dotglob

# Use extended pattern matching for path expansion.
shopt -s extglob

# Append to history file rather than overwrite.
shopt -s histappend

# Disable mail warnings.
shopt -u mailwarn

# ---------------------------------------------------------------------
# SHELL VARIABLES (PATHS)
# ---------------------------------------------------------------------

# Set basic paths. Prefer my commands, then local, then system.
export PATH=~/bin:~/sys/bin:~/node_modules/.bin:/usr/local/bin:/usr/local/sbin:/opt/local/bin:/opt/local/sbin:/usr/local/share/npm/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/lib:/usr/proc/bin:/usr/ucb:/etc
#export LD_LIBRARY_PATH=/usr/local/lib:/lib:/usr/lib:/usr/share/lib
#export MANPATH=~/sys/man:/usr/local/man:/opt/local/man:/usr/man:/usr/share/man:/usr/local/share/man
#export NODE_PATH=/usr/local/lib/node_modules
export JRUBY_OPTS=-J-Xmx2g
MYSQL=/usr/local/mysql/bin
ACTIVATOR=~/src/activator-dist-1.3.7/bin
export PATH=$PATH:$MYSQL:$ACTIVATOR
export DYLD_LIBRARY_PATH=/usr/local/mysql/lib:$DYLD_LIBRARY_PATH

#if [[ "$LANG" == "en_US.UTF-8" ]]; then
#    export NLS_LANG="AMERICAN_AMERICA.AL32UTF8"
#fi

# Tell the world about our shell.
export SHELL=$(which bash)

# Need this general variable to set paths.
UNAME=$(uname)

# Set file type colors for use with `ls` (should color be available).
# ... BSD (e.g. MacOS X):
export LSCOLORS="Hxfxcxdxbxegedabagacad"
# ... GNU (e.g. Linux):
export LS_COLORS="di=1;37;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:"

# Set the the timestamp used for history output.
export HISTTIMEFORMAT="%D %T "

# Set the GnuPG tty.
export GPG_TTY=$(tty)

# Specify inputrc file.
export INPUTRC=~/.inputrc

# Shell history settings.
export HISTFILESIZE=5000
export HISTSIZE=5000
export HISTCONTROL=ignoreboth
export HISTTIMEFORMAT="%d/%m/%y %T "

# Don't check on mail.
unset MAILCHECK

# Command options.
export GREP_OPTIONS='--color=auto'

# Set editor variables.
export VISUAL=$(type -p vim || type -p vi)
export EDITOR=$(type -p vim || type -p vi)
export GUIEDITOR=$(type -p mvim || type -p gvim)

# Append history immediately after typing them (avoids multi-window problem).
PROMPT_COMMAND='history -a'

# Set pager variables.
export PAGER=$(type -p less || type -p more)
export MANPAGER=$PAGER

if [[ $(less -V 2>/dev/null | awk '/less [0-9]/{print $2}') -lt 346 ]]; then
    export LESS="-qiX"
else
    export LESS="-FqiRWX"
fi

# Set terminal type.
if [[ "$(tty)" = "/dev/console" ]]; then
    export TERM=vt100
elif [[ "$TERM" = screen* && -z "$TMUX" ]]; then
    infocmp screen > /dev/null 2>&1 && export TERM=screen
    infocmp screen-256color > /dev/null 2>&1 && export TERM=screen-256color
    if [[ "$UNAME" = "SunOS" ]]; then
        infocmp dtterm > /dev/null 2>&1 && export TERM=dtterm
    fi
elif [[ -n "$TMUX" ]]; then
    infocmp screen > /dev/null 2>&1 && export TERM=screen
    infocmp screen-256color > /dev/null 2>&1 && export TERM=screen-256color
    if [[ "$UNAME" = "SunOS" ]]; then
        infocmp dtterm > /dev/null 2>&1 && export TERM=dtterm
    fi
else
    infocmp vt100 > /dev/null 2>&1 && export TERM=vt100
    infocmp xterm > /dev/null 2>&1 && export TERM=xterm
    infocmp xterm-color > /dev/null 2>&1 && export TERM=xterm-color
    infocmp xterm-256color > /dev/null 2>&1 && export TERM=xterm-256color
    if [[ "$UNAME" = "SunOS" ]]; then
        infocmp dtterm > /dev/null 2>&1 && export TERM=dtterm
    fi
fi

# Set number of colors after determining TERM.
if [[ "$TERM" == "dtterm" ]]; then
    export MYCOLORS=256
else
    export MYCOLORS=$(tput colors)
fi

# ---------------------------------------------------------------------
# PROMPT
# ---------------------------------------------------------------------

color16() { echo -ne "\[\033[${1}m\]"; }
color256() { echo -ne "\[\033[38;5;${1}m\]"; }

NOCOLOR="$(color16 '0')"

if [[ $MYCOLORS -gt 255 ]]; then
    BLUE="$(color256 '33')"
    CYAN="$(color256 '37')"
    GREEN="$(color256 '64')"
    GREY="$(color256 '241')"
    MAGENTA="$(color256 '125')"
    ORANGE="$(color256 '166')"
    RED="$(color256 '124')"
    VIOLET="$(color256 '61')"
    WHITE="$(color256 '254')"
    YELLOW="$(color256 '136')"
elif [[ $MYCOLORS -gt 7 ]]; then
    BLUE="$(color16 '1;34')"
    CYAN="$(color16 '1;36')"
    GREEN="$(color16 '1;32')"
    GREY="$(color16 '1;30')"
    MAGENTA="$(color16 '1;34')"
    ORANGE="$(color16 '1;33')"
    RED="$(color16 '1;31')"
    VIOLET="$(color16 '1;35')"
    WHITE="$(color16 '1;37')"
    YELLOW="$(color16 '1;33')"
fi

CLRDIR=$WHITE
CLRGIT=$YELLOW
CLRGITCHG=$RED
CLRGITSTASH=$RED
CLRHOST=$GREY
CLRRB=$VIOLET
CLRPY=$GREEN

if [[ "root" == "$(whoami)" ]]; then
    CLRID=$RED
else
    CLRID=$GREEN
fi

CLRJBS=$RED
CLRNONE=$NOCOLOR
CLRPRMT=$GREY

if [[ -x "$(type -p locale)" && $(locale | grep UTF | wc -l) -gt 0 ]]; then
    UTF=1
else
    UTF=0
fi

ps_id() {
    echo -n "$(whoami) "
}

ps_host() {
    echo -ne "\h "
}

ps_dir() {
    echo -ne "\w "
}

ps_jobs() {
    local jbs=$(jobs 2>/dev/null | wc -l | awk '{print $1}')
    if test $jbs -gt 0; then
        echo -ne "[$jbs] "
    fi
}

ps_git() {
    git rev-parse > /dev/null 2>&1 && {
        echo -n "$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"
    }
}

ps_git_chg() {
    git rev-parse > /dev/null 2>&1 && {
        if test $(git status -s --ignore-submodules=dirty 2> /dev/null | wc -l) -gt 0; then
            if test $UTF -gt 0; then
                echo -n ' Δ'
            else
                echo -n " *"
            fi
        fi
        if test $(git stash list 2> /dev/null | wc -l) -gt 0; then
            if test $UTF -gt 0; then
                echo -n ' §'
            else
                echo -n ' #'
            fi
        fi
        echo -n " "
    }
}

ps_rb() {
    if rbenv version > /dev/null 2>&1; then
        if [ -f "$(pwd)/.ruby-version" -o -f "$(pwd)/.ruby-version" ] && rbenv version-name > /dev/null 2>&1; then
            echo -n "Ruby $(rbenv version-name)"
            if [ -f $(pwd)/.rbenv-gemsets ] && rbenv gemset active > /dev/null 2>&1; then
                echo -n "Ruby @$(rbenv gemset active)"
            fi
            echo -n " "
        fi
    elif type -p rvm > /dev/null 2>&1; then
        if [ -f "$(pwd)/.rvmrc" -a "$(pwd)" != "$HOME" ]; then
            if [ -x ~/.rvm/bin/rvm-prompt ]; then
                echo -n "Ruby $(~/.rvm/bin/rvm-prompt) "
            fi
        fi
    fi
}

ps_py() {
    if [ -d __pycache__  -o -f *.pyc ]; then
        echo -n "$(python --version) "
    fi
}

ps_prompt() {
    if test $UTF -gt 0; then
        echo -n "▶ "
    else
        echo -n "> "
    fi
}

export
PS1="${CLRHOST}$(ps_host)${CLRID}"'$(ps_id)'"${CLRDIR}$(ps_dir)${CLRJBS}"'$(ps_jobs)'"${CLRPY}"'$(ps_py)'"${CLRRB}"'$(ps_rb)'"${CLRGIT}"'$(ps_git)'"${CLRGITCHG}"'$(ps_git_chg)'"${CLRPRMT}$(ps_prompt)${CLRNONE}"

# ---------------------------------------------------------------------
# COMMANDS & ALIASES
# ---------------------------------------------------------------------

# bundler
alias be='bundle exec'

# cat
alias c='cat'

# ctags
alias cr='ctags -R .'

# Editor.
alias e=$EDITOR

if [[ "$EDITOR" = "$(type -p vim)" ]]; then
    if $(vim --version | awk '{ if ($5 >= 7.0) { exit(0) } else { exit(1) } }'); then
        alias e="$EDITOR -p"
    fi

    alias eh="$EDITOR -c ':help | only'"
fi

[[ -n "$GUIEDITOR" ]] && eg() {
    [[ $# < 1 ]] && $GUIEDITOR || $GUIEDITOR -p --remote-tab-silent $@
}

# grep/egrep
alias g='egrep -i'
alias gl='egrep -il'
alias glr='egrep -ilR'
alias gr='egrep -iR'
alias gv='egrep -iv'

if [[ $UNAME == "SunOS" ]]; then
    alias gq='/usr/xpg4/bin/egrep -iq'
elif [[ $UNAME == "Darwin" ]]; then
    alias gq='/usr/bin/egrep -iq'
fi

# keychain (requires extended globbing)
alias k='keychain --nogui ~/.ssh/id_!(*.pub) && source ~/.keychain/$(hostname)-sh'

# ls
ls -G &> /dev/null
test $? -eq 0 && CR="-G"
ls --color &> /dev/null
test $? -eq 0 && CR="--color=auto"
alias la="ls -Al $CR"
alias l="ls -al $CR"
alias lf='ls -F'
alias lt="ls -lAt $CR"

# Pager.
alias m=$PAGER

# ps
PSARGS="user,pid,args"
test "$(uname -sr)" = "SunOS 5.10" && PSARGS="zone,$PSARGS"
alias pg="ps -eo $PSARGS | egrep -i"
alias pgv="ps -eo $PSARGS | egrep -iv"
alias pm="ps -eo $PSARGS | more"
test "$UNAME" = "Linux" && alias pm="ps -Heo $PSARGS | more"

# tmux
alias t='tmux'
alias ta='tmux att -t'
alias tl='tmux ls'
alias tn='tmux_new_session'
alias tp='tmux_new_project'

# Print out 256 terminal color spectrum.
colors() {
    for i in {0..255} ; do
        printf "\x1b[38;5;${i}mcolor ${i}\n"
    done
}

# Print out 256 terminal color spectrum, tmux-style.
colors_tmux() {
    for i in {0..255}; do
        printf "\x1b[38;5;${i}mcolour${i}\n"
    done
}

# Process control.
# alias f='fg'
# alias j='jobs'

# ---------------------------------------------------------------------
# ENVIRONMENT
# ---------------------------------------------------------------------

# SSH & GnuPG keys.
[[ -s ~/.keychain/$(hostname)-sh ]] && source ~/.keychain/$(hostname)-sh

# Setup external bash completions.
test -d /usr/local/etc/bash_completion.d && for f in $(ls /usr/local/etc/bash_completion.d | grep -v ack); do
    source /usr/local/etc/bash_completion.d/$f
done

if [[ -e /usr/local/git/contrib/completion/git-completion.bash ]]; then
    source /usr/local/git/contrib/completion/git-completion.bash
fi

# ---------------------------------------------------------------------
# EXTERNAL SETUP
# ---------------------------------------------------------------------

test -d ~/.bash.d && for f in $(ls ~/.bash.d); do source ~/.bash.d/$f; done
test -f ~/.bash_local && source ~/.bash_local

# export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

# export NVM_DIR="/Users/ngarza10/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# export PATH=~/Library/Python/3.6/bin:$PATH

alias sing="echo 'SING! SIXpence'"

# export NLTK_DATA="/Users/ngarza10/src/NLT"
