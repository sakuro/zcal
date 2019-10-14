#!/bin/zsh

function zcal::date-color() {
  local day_of_week=$1
  local holiday=$2
  local -a day_colors
  local holiday_color

  zstyle -a ':zcal:' day-colors day_colors || day_colors=(gray gray gray gray gray blue red)
  zstyle -s ':zcal:' holiday-color holiday_color || holiday_color=red

  if [[ -n "$holiday" ]]; then
    print $holiday_color
  elif [[ -n "$day_of_week" ]]; then
    print "${day_colors[$day_of_week]}"
  else
    print ''
  fi
}

function zcal::print-l() {
  while [[ $# -gt 0 ]]; do
    local -a fields=(${(s.:.)1})
    local color="$(zcal::date-color "${fields[2]}" "${fields[3]}")"
    print -P "%F{$color}$fields[@]%f"
    shift
  done
}

function zcal::print-x() {
  local -a info=(${(s.:.)1})
  local head=${info[1]%-*}
  local indent=$(( $info[2] - 1 ))
  while [[ $indent -gt 0 ]]; do
    set -- "::" "$@"
    indent=$((indent - 1))
  done

  print $head
  while [[ $# -gt 0 ]]; do
    local -a fields=(${(s.:.)1})
    local color="$(zcal::date-color "${fields[2]}" "${fields[3]}")"
    local date_fields=(${(s:-:)fields[1]})
    local date=${(l:2:)date_fields[3]}
    if [[ $fields[2] = 7 || $# = 1 ]]; then
      print -P "%F{$color}$date%f"
    else
      print -nP "%F{$color}$date%f "
    fi
    shift
  done
}
