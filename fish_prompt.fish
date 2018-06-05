# name: trixie
function _git_branch_name
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
  echo (command git status -s --ignore-submodules=dirty ^/dev/null)
end

function _pretty_cwd -S -a cwd
  set -l bold (set_color -o)
  set -l normal (set_color normal)

  echo -n -s "$cwd" | sed 's|[^/]*$|'$bold'&'$normal'|'
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

  set -l cwd
  if test "$theme_short_path" = 'yes'
    set cwd $blue(basename (prompt_pwd))
  else
    set cwd $blue(_pretty_cwd (prompt_pwd))
  end

  set -l git_info
  if [ (_git_branch_name) ]
    set git_info $green(_git_branch_name)
    set git_info "$normal$theme_separator$git_info"

    if [ (_is_git_dirty) ]
      set -l dirty "*"
      set git_info "$git_info$dirty"
    end
  end

  echo -n -s $cwd $git_info $normal $theme_separator $theme_arrow ' '
end

# vim: et:ts=2:sw=2
