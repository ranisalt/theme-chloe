# name: L
function _git_branch_name
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
  echo (command git status -s --ignore-submodules=dirty ^/dev/null)
end

function fish_prompt
  set -l blue (set_color blue)
  set -l green (set_color green)
  set -l normal (set_color normal)

  set -q theme_arrow
    or set -l theme_arrow "lambda"

  set -l arrow
  switch "$theme_arrow"
    case "fish"
      set arrow "⋊>"
    case "lambda"
      set arrow "λ"
    case "*"
      set arrow "$theme_arrow"
  end

  set -l cwd
  if test "$theme_short_path" = 'yes'
    set cwd $blue(basename (prompt_pwd))
  else
    set cwd $blue(prompt_pwd)
  end

  if [ (_git_branch_name) ]
    set git_info $green(_git_branch_name)
    set git_info ":$git_info"

    if [ (_is_git_dirty) ]
      set -l dirty "*"
      set git_info "$git_info$dirty"
    end
  end

  echo -n -s $cwd $git_info $normal ' ' $arrow ' '
end
