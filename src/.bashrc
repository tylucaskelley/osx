#!/usr/bin/env bash

# bashrc
#
# bash settings
# --------

# load dotfiles

files=(
  ~/.aliases
  ~/.exports
  ~/.functions
  ~/.gitprompt
  ~/.environment # placed last for precedence
)

for file in "${files[@]}"; do
  if [ -f "$file" ]; then
    # shellcheck disable=SC1090
    source "$file"
  fi
done

# bash options

options=(
  histappend
  cdspell
  globstar
  dotglob
  cmdhist
  dirspell
  nocaseglob
)

for option in "${options[@]}"; do
  shopt -s "$option"
done

# bash completion

if [[ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]]; then
  export BASH_COMPLETION_COMPAT_DIR
  BASH_COMPLETION_COMPAT_DIR="$(brew --prefix)/etc/bash_completion.d"

  # shellcheck disable=SC1090
  source "$(brew --prefix)/etc/profile.d/bash_completion.sh"
fi

bind "set show-all-if-ambiguous on"

# completion for macos "defaults" command

complete -W "NSGlobalDomain" defaults;

# git completion

if [[ -f "$(brew --prefix)/etc/bash_completion.d/git-completion.bash" ]]; then
  # shellcheck disable=SC1090
  source "$(brew --prefix)/etc/bash_completion.d/git-completion.bash"

  # completion for g alias
  __git_complete g __git_main
fi

# autojump

if [ -f "$(brew --prefix)/etc/profile.d/autojump.sh" ]; then
  # shellcheck disable=SC1090
  source "$(brew --prefix)/etc/profile.d/autojump.sh"
fi

# github cli

# TODO: bring back after https://github.com/github/hub/issues/2684 fixed
# if [ -f "$(brew --prefix hub)/etc/bash_completion.d/hub.bash_completion.sh" ]; then
  # # shellcheck disable=SC1090
  # source "$(brew --prefix hub)/etc/bash_completion.d/hub.bash_completion.sh"
# fi

# nodenv (node version manager)

if [[ -s "$(brew --prefix nodenv)" ]]; then
  eval "$(nodenv init -)"
fi

# rbenv (ruby version manager)

if [[ -s "$(brew --prefix rbenv)" ]]; then
  eval "$(rbenv init -)"
fi

# pyenv (python version manager)

if [[ -s "$(brew --prefix pyenv)" ]]; then
  eval "$(pyenv init -)"
fi

# pip

if command -v pip &> /dev/null; then
  eval "$(pip completion --bash)"
fi

# pipenv

if command -v pipenv &> /dev/null; then
  eval "$(pipenv --completion)"
fi

# poetry

if command -v poetry &> /dev/null; then
  poetry completions bash > "$(brew --prefix)/etc/bash_completion.d/poetry.bash-completion"
fi

# trellis

if command -v trellis &> /dev/null; then
  complete -C /usr/local/bin/trellis trellis
fi

# load bash prompt

if [ -f ~/.bash_prompt ]; then
  # shellcheck disable=SC1090
  source ~/.bash_prompt
  PROMPT_COMMAND="set_prompt; autojump_add_to_database; history -a; history -c; history -r"
fi

# direnv - needs to be last

if command -v direnv &> /dev/null; then
  eval "$(direnv hook bash)"
fi