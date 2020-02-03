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

function array::rotate-left() {
  local offset=$1
  shift
  local values=("$@")
  local result=( "${values[@]:$offset:$(($#values - offset))}" "${values[@]:0:$offset}" )
  echo "${result[@]}"
}

function zcal::day-of-week-labels() {
  local start=$1
  local -A day_of_week_labels=(1 Mo 2 Tu 3 We 4 Th 5 Fr 6 Sa 7 Su)
  local -a colored_labels=()
  for w in "${(nk)day_of_week_labels[@]}"; do
    colored_labels+=( "$(print -nP "%F{$(zcal::date-color $w)}${day_of_week_labels[$w]}%f")" )
  done
  local -a result=( $(array::rotate-left $((start - 1)) ${colored_labels[@]}) )

  print "${(j: :)result[@]}"
}

function zcal::print() {
  local -a info=(${(s.:.)1})
  local year_month=${info[1]%-*}
  local indent=$(( $info[2] - 1 ))
  while [[ $indent -gt 0 ]]; do
    set -- "::" "$@"
    indent=$((indent - 1))
  done

  print "${(l:10:r:10:)year_month}"
  zcal::day-of-week-labels 1
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
