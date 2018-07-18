# To show the right prompt please set
# set theme_display_pyenv 'yes' (config.fish)

function _python_version
  set -q theme_display_timestamp
    or set -l theme_display_timestamp 'yes'
  if [ "$theme_display_pyenv" != 'yes' ]
    return
  end

  set -l dummy (type pyenv ^/dev/null)
  if [ $status -gt 0 ]
    return
  end

  set -l version
  if set -q VIRTUAL_ENV
    set -l _venv (basename (dirname "$VIRTUAL_ENV"))
    set -l _version (command python --version | awk '{print $2}')
    set version "$_version ($_venv)"
  else
    set version (command pyenv version-name)
    if [ "$version" = "system" ]
      return
    end
  end

  echo -n '' $version
end

function _timestamp
  set -q theme_display_timestamp
    or set -l theme_display_timestamp 'yes'
  if [ "$theme_display_timestamp" != 'yes' ]
    return
  end

  set -q theme_date_format
    or set -l theme_date_format '+%R'

  date "$theme_date_format"
end

function fish_right_prompt
  set -l yellow (set_color yellow)
  set -l shadow (set_color $fish_color_comment)

  set python_info $yellow(_python_version)
  set timestamp $shadow(_timestamp)

  echo -n $python_info $timestamp
  set_color normal
end

# vim: et:ts=2:sw=2
