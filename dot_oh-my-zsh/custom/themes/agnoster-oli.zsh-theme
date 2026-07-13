# vim:ft=zsh ts=2 sw=2 sts=2
#
# # README
#
# This is an customisation of agnoster's Theme - https://gist.github.com/3712874
# Adds minimal macOS light/dark awareness


### Segments of the prompt, default order declaration
typeset -aHg AGNOSTER_PROMPT_SEGMENTS=(
    prompt_status
    prompt_context
    prompt_virtualenv
    prompt_dir
    prompt_git
    prompt_end
)

### Segment drawing
# A few utility functions to make it easy and re-usable to draw segmented prompts

CURRENT_BG='NONE'
if [[ -z "$PRIMARY_FG" ]]; then
	PRIMARY_FG=black
fi

### macOS light/dark-aware palette
# Re-reads the system appearance on every prompt (~7ms) so toggling
# System Settings → Appearance updates the prompt on your next Enter.
# Tweak the color names below to taste; any zsh color name works
# (black red green yellow blue magenta cyan white, or a 0-255 number).
typeset -g PROMPT_APPEARANCE=''
# Sane defaults until the first precmd runs.
PROMPT_DIR_BG='blue'; PROMPT_DIR_FG=$PRIMARY_FG; PROMPT_STATUS_BG=$PRIMARY_FG
prompt_update_palette() {
  local appearance
  # `defaults read -g AppleInterfaceStyle` prints "Dark" in dark mode
  # and errors (empty) in light mode.
  if [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" == Dark ]]; then
    appearance=dark
  else
    appearance=light
  fi
  [[ $appearance == $PROMPT_APPEARANCE ]] && return   # unchanged: skip
  PROMPT_APPEARANCE=$appearance

  if [[ $appearance == dark ]]; then
    PROMPT_DIR_BG='blue'       # directory segment background
    PROMPT_DIR_FG='black'      # directory segment text
    PROMPT_STATUS_BG='black'   # leftmost status box (✘ / ⚡ / ⚙) background
  else
    PROMPT_DIR_BG='110'        # soft blue in light mode
    PROMPT_DIR_FG='black'
    PROMPT_STATUS_BG='252'     # light grey in light mode
  fi
}

# Characters
SEGMENT_SEPARATOR="\ue0b0"
PLUSMINUS="\u00b1"
BRANCH="\ue0a0"
DETACHED="\u27a6"
CROSS="\u2718"
LIGHTNING="\u26a1"
GEAR="\u2699"

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    print -n "%{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%}"
  else
    print -n "%{$bg%}%{$fg%}"
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && print -n $3
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    print -n "%{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    print -n "%{%k%}"
  fi
  print -n "%{%f%}"
  CURRENT_BG=''
}

### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown

# Context: user@hostname (who am I and where am I)
prompt_context() {
  local user=`whoami`

  if [[ "$user" != "$DEFAULT_USER" || -n "$SSH_CONNECTION" ]]; then
    prompt_segment $PROMPT_STATUS_BG default " %(!.%{%F{yellow}%}.)$user@%m "
  fi
}

# Git: branch/detached head, dirty status
prompt_git() {
  local color ref
  is_dirty() {
    test -n "$(git status --porcelain --ignore-submodules)"
  }
  ref="$vcs_info_msg_0_"
  if [[ -n "$ref" ]]; then
    if is_dirty; then
      color=yellow
      ref="${ref} $PLUSMINUS"
    else
      color=green
      ref="${ref} "
    fi
    if [[ "${ref/.../}" == "$ref" ]]; then
      ref="$BRANCH $ref"
    else
      ref="$DETACHED ${ref/.../}"
    fi
    prompt_segment $color $PRIMARY_FG
    print -n " $ref"
  fi
}

# Dir: current working directory
prompt_dir() {
  prompt_segment $PROMPT_DIR_BG $PROMPT_DIR_FG ' %~ '
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  local symbols
  symbols=()
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}$CROSS"
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}$LIGHTNING"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}$GEAR"

  [[ -n "$symbols" ]] && prompt_segment $PROMPT_STATUS_BG default " $symbols "
}

# Display current virtual environment
prompt_virtualenv() {
  if [[ -n $VIRTUAL_ENV ]]; then
    color=cyan
    prompt_segment $color $PRIMARY_FG
    print -Pn " $(basename $VIRTUAL_ENV) "
  fi
}

## Main prompt
prompt_agnoster_main() {
  RETVAL=$?
  CURRENT_BG='NONE'
  for prompt_segment in "${AGNOSTER_PROMPT_SEGMENTS[@]}"; do
    [[ -n $prompt_segment ]] && $prompt_segment
  done
}

# Comment out `prompt_update_palette`if you're not using dynamic themes
# in your terminal
prompt_agnoster_precmd() {
  prompt_update_palette
  vcs_info
  PROMPT='%{%f%b%k%}$(prompt_agnoster_main) '
}

prompt_agnoster_setup() {
  autoload -Uz add-zsh-hook
  autoload -Uz vcs_info

  prompt_opts=(cr subst percent)

  add-zsh-hook precmd prompt_agnoster_precmd

  zstyle ':vcs_info:*' enable git
  zstyle ':vcs_info:*' check-for-changes false
  zstyle ':vcs_info:git*' formats '%b'
  zstyle ':vcs_info:git*' actionformats '%b (%a)'
}

prompt_agnoster_setup "$@"
