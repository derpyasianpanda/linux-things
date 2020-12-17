# History and caching
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.cache/zsh/history

setopt autocd extendedglob notify
setopt COMPLETE_ALIASES
unsetopt beep nomatch
setopt prompt_subst

# Auto complete
zstyle :compinstall filename "/home/lecongkhoiviet/.zshrc"
zstyle ":completion::complete:*" gain-privileges 1
zstyle ":completion:*" menu select
_comp_options+=(globdots) # Auto complete hidden files
zmodload zsh/complist
autoload -Uz compinit
compinit

# Vi Mode options
bindkey -v
autoload edit-command-line; zle -N edit-command-line
bindkey "^e" edit-command-line
# Change cursor shape for different vi modes.
function vi_mode_prompt_info() {
  echo "${${KEYMAP/vicmd/[% NORMAL]%}/(main|viins)/[% INSERT]%}"
}
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = "block" ]]; then
    echo -ne "\e[1 q"
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = "" ]] ||
       [[ $1 = "beam" ]]; then
    echo -ne "\e[5 q"
  fi
  zle reset-prompt
  zle -R
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne "\e[5 q" # Use beam shape cursor on startup.
preexec() { echo -ne "\e[5 q" ;} # Use beam shape cursor for each new prompt.
bindkey -M menuselect "^P" vi-up-line-or-history
bindkey -M menuselect "^N" vi-down-line-or-history

# define right prompt, regardless of whether the theme defined it
RPS1='$(vi_mode_prompt_info)'
RPS2=$RPS1

# Custom lines
alias ls="ls --color=auto"
alias nf="neofetch"
alias la="ls -A"
alias mv="mv -i"
alias rm="rm -I"
alias cp="cp -i"
alias grep="grep --color=auto"
alias vim="nvim"
alias rice="cd ~/linux-things/dotfiles"

source $HOME/.config/le-agnoster.zsh-theme

# Color Scheme Application (wpgtk)
# (cat $HOME/.config/wpg/sequences &)

# Proper Kitty autocompletion
kitty + complete setup zsh | source /dev/stdin

# Variables
export EDITOR=nvim
export VISUAL=nvim
