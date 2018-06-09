# name: trixie

function _git_dirty
  set -q theme_dirty_symbol
    or set -l theme_dirty_symbol '±'

  set -l dirty (command git status -s --ignore-submodules=dirty ^/dev/null)
  if [ -n "$dirty" ]
   echo -n "$theme_dirty_symbol"
  end
end

function _git_ref
  set -q theme_branch_symbol
    or set -l theme_branch_symbol \uE0A0

  set -q theme_detached_symbol
    or set -l theme_detached_symbol '➦'

  set -l ref (command git symbolic-ref HEAD ^/dev/null)
  if [ $status -gt 0 ]
    set -l branch (command git show-ref --head -s --abbrev | head -n1 ^/dev/null)
    echo -ns $theme_detached_symbol $branch
  else
    set -l branch (string sub -s 12 -- "$ref")
    echo -ns $theme_branch_symbol $branch
  end
end

function prompt_git
  if command git rev-parse --is-inside-work-tree >/dev/null ^/dev/null
    echo -ns (_git_ref) (_git_dirty)
  end
end

function prompt_cwd -S -a cwd
  set -l bold (set_color -o)
  set -l normal (set_color normal)

  echo -ns $cwd | sed 's|[^/]*$|'$bold'&'$normal'|'
end

function fish_prompt
  set -l blue (set_color blue)
  set -l brblue (set_color brblue)
  set -l green (set_color green)
  set -l normal (set_color normal)

  set -q theme_arrow
    or set -l theme_arrow "λ"

  set -q theme_separator
    or set -l theme_separator " "
  set sep "$normal$theme_separator"

  set -l prompt

  if test "$theme_short_path" = 'yes'
    set prompt $blue(basename (prompt_pwd))
  else
    set prompt $blue(prompt_cwd (prompt_pwd))
  end

  set -l git_info (prompt_git)
  if [ -n "$git_info" ]
    set prompt "$prompt$sep$green$git_info$normal"
  end

  echo -ns $prompt $sep $theme_arrow ' '
end

# vim: et:ts=2:sw=2
