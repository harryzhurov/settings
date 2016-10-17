
# Command history
HISTFILE=~/.zsh-history
HISTSIZE=5000
SAVEHIST=5000

setopt appendhistory
setopt HIST_IGNORE_ALL_DUPS 
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt INC_APPEND_HISTORY

#bindkey "^[[A" up-line-or-search
#bindkey "^[[B" down-line-or-search
bindkey "\eOA" up-line-or-search
bindkey "\eOB" down-line-or-search

bindkey '^[[1;5D'   backward-word
bindkey '^[[1;5C'   forward-word

bindkey '\e[5~' up-line-or-history              # page-up
bindkey '\e[6~' down-line-or-history            # page-down

# Search path for the cd command
cdpath=(.. ~ ~/slon/ ~/incoming ~/pro/ ~/pro/racurs/ ~/cad ~/etc/settings/)

# Use hard limits, except for a smaller stack and no core dumps
unlimit
limit stack 8192
limit core 0
limit -s

umask 022

# Set up aliases and environment variables
source ~/.aliases
source ~/.env

# Shell functions
setenv() { typeset -x "${1}${1:+=}${(@)argv[2,$#]}" }  # csh compatibility
freload() { while (( $# )); do; unfunction $1; autoload -U $1; shift; done }

# Where to look for autoloaded function definitions
fpath=($fpath ~/.zfunc)

# Autoload all shell functions from all directories in $fpath (following
# symlinks) that have the executable bit on (the executable bit is not
# necessary, but gives you an easy way to stop the autoloading of a
# particular shell function). $fpath should not be empty for this to work.
for func in $^fpath/*(N-.x:t); autoload $func

# automatically remove duplicates from these arrays
typeset -U path cdpath fpath manpath

# Global aliases -- These do not have to be
# at the beginning of the command line.
alias -g M='|more'
alias -g H='|head'
alias -g T='|tail'
alias -g L='|less -M'


#  File assosiations

function background() { "$@" & }

alias -s {avi,mpeg,mpg,mov,m2v}='~/bin/background parole &>/dev/null'
alias -s {odt,doc,sxw,rtf,ods}='~/bin/background libreoffice'
alias -s pdf='~/bin/background qpdfview --unique'
autoload -U pick-web-browser
alias -s {html,htm}='~/bin/background vivaldi-beta >/dev/null'
alias -s vpw='~/bin/background vs.sh'

#manpath=($X11HOME/man /usr/man /usr/lang/man /usr/local/man)
#export MANPATH

# Hosts to use for completion (see later zstyle)
hosts=(`hostname` ftp.math.gatech.edu prep.ai.mit.edu wuarchive.wustl.edu)


# Set colors
autoload -U colors && colors

for color in red green yellow blue magenta cyan black white; do
    eval $color='%{$fg_no_bold[${color}]%}'
    eval ${color}_bold='%{$fg_bold[${color}]%}'
done

reset="%{$reset_color%}"


man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;246m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}


# Some environment variables
export MAIL=/var/spool/mail/$USERNAME
export LESS=-cex3M
export HELPDIR=/usr/share/zsh/$ZSH_VERSION/help  # directory for run-help function to find docs

BFIN_ELF_MAN="$CAD/adi/bfin-elf/man:$CAD/adi/bfin-elf/share/man"
GCC_ARM_MAN="/$CAD/gcc/arm/share/doc/gcc-arm-none-eabi/man"

export MANPATH="$MANPATH:/usr/share/man:$BFIN_ELF_MAN:$GCC_ARM_MAN"

export GREP_COLORS="mt=33"
#export GREP_OPTIONS='--color=auto'


MAILCHECK=300
HISTSIZE=200
DIRSTACKSIZE=20

# Watch for my friends
#watch=( $(<~/.friends) )       # watch for people in .friends file
watch=(notme)                   # watch for everybody but me
LOGCHECK=300                    # check every 5 min for login/logout activity
WATCHFMT='%n %a %l from %m at %t.'

# Set/unset  shell options
setopt   notify globdots correct pushdtohome cdablevars autolist
setopt   correctall autocd recexact longlistjobs nomatch
setopt   autoresume pushdsilent noclobber
setopt   autopushd pushdminus extendedglob rcquotes mailwarning
unsetopt bgnice autoparamslash beep

setopt IGNORE_EOF

# Autoload zsh modules when they are referenced
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof
zmodload -ap zsh/mapfile mapfile
# stat(1) is now commonly an external command, so just load zstat
zmodload -aF zsh/stat b:zstat

# Some nice key bindings
#bindkey '^X^Z' universal-argument ' ' magic-space
#bindkey '^X^A' vi-find-prev-char-skip
#bindkey '^Xa' _expand_alias
#bindkey '^Z' accept-and-hold
#bindkey -s '\M-/' \\\\
#bindkey -s '\M-=' \|

# bindkey -v               # vi key bindings

bindkey -e                 # emacs key bindings
bindkey -r '\ex'           # unbind 'alt-x' hotkey
bindkey ' ' magic-space    # also do history expansion on space
bindkey '^I' complete-word # complete on tab, leave expansion to _expand

# Setup new style completion system. To see examples of the old style (compctl
# based) programmable completion, check Misc/compctl-examples in the zsh
# distribution.
autoload -Uz compinit
compinit

# Completion Styles

# list of completers to use
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate

# allow one error for every three characters typed in approximate completer
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'
    
# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions

# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:*' use-compctl false
zstyle :compinstall filename '/home/zsh/.zshrc'

# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# command for process lists, the local web server details and host completion
#zstyle ':completion:*:processes' command 'ps -o pid,s,nice,stime,args'
#zstyle ':completion:*:urls' local 'www' '/var/www/htdocs' 'public_html'
zstyle '*' hosts $hosts

# Filename suffixes to ignore during completion (except after rm command)
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' \
    '*?.old' '*?.pro'
# the same for old style completion
#fignore=(.o .c~ .old .pro)

# ignore completion functions (until the _ignored completer)
zstyle ':completion:*:functions' ignored-patterns '_*'

if [[ -f ~/local/bin/mc ]]; then
    alias mc='~/local/bin/mc'
fi

export LANGUAGE='en_US.UTF-8'
export TERM=xterm-256color

source ~/etc/zsh/zsh-git-prompt/zshrc.sh

# Set prompts
PROMPT='${cyan}%n@%m${reset}:${blue_bold}%~${reset}$(git_super_status)${reset}%(!.#.$)${reset} '

#PROMPT2='%i%U> ' 
#RPROMPT=" ${cyan}%T ${magenta}%y%b${reset}" # prompt for right side of screen

case $TERM in
    xterm*|rxvt*|screen*)
        precmd()  { print -Pn "\e]0;%m:%\a" }
        preexec() { print -Pn "\e]0;$1\a" }
        ;;
esac

#  syntax highlighting

typeset -A ZSH_HIGHLIGHT_STYLES

ZSH_HIGHLIGHT_STYLES=(
        'alias'           'fg=153,bold'
        'builtin'         'fg=153'
        'function'        'fg=166'
        'command'         'fg=153'
        'precommand'      'fg=153, underline'
        'hashed-commands' 'fg=153'
        'path'            'underline'
        'globbing'        'fg=166'
)

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
#SH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
#ZSH_HIGHLIGHT_STYLES[cursor]='bg=blue'

source /home/hz/etc/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


