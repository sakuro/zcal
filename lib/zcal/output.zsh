#!/bin/zsh

function zcal::date-color() {
  local date=$1
  local day_of_week=$2
  local holiday=$3

  if [[ -n "$holiday" ]]; then
    echo red
  else
    case "${day_of_week}" in
    6) echo blue ;;
    7) echo red ;;
    *) echo gray ;;
    esac
  fi
}

function zcal::print-l() {
  while [[ $# -gt 0 ]]; do
    local fields=(${(s.:.)1})
    local color="$(zcal::date-color "${fields[@]}")"
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

  echo $head
  while [[ $# -gt 0 ]]; do
    local -a fields=(${(s.:.)1})
    local color="$(zcal::date-color "${fields[@]}")"
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
