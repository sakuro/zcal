#!/bin/zsh

function zcal::days-in-month() {
  local year="$1"
  local month="$2"
  local end_of_month=$(zcal::end-of-month "${year}" "${month}")
  local dates=( "${year}-${month}-"{1.."${end_of_month}"} )
  local weekdays=( {1..7} {1..7} )
  local first_day_of_week="$(date -d "${year}"-"${month}"-1 +%u)"
  weekdays=( ${weekdays:$((first_day_of_week - 1)):7} )
  local zipped=( ${dates:^^weekdays} )
  local -A holidays=( $(zcal::load-holidays-cache "${year}") )

  while [[ "${#zipped}" -gt 0 ]]; do
    echo "${zipped[1]}:${zipped[2]}:$holidays[$zipped[1]]"
    shift 2 zipped
  done
}

function zcal::end-of-month() {
  local year=$1
  local month=$2
  local days=( 31 $($(zcal::leap-year $year) && echo 29 || echo 28) 31 30 31 30 31 31 30 31 30 31 )
  echo ${days[$month]}
}

function zcal::leap-year() {
  local year=$1
  if [[ $(($year % 400)) = 0 ]]; then
    return 0
  fi
  if [[ $(($year % 100)) = 0 ]]; then
    return 1
  fi
  if [[ $(($year % 4)) = 0 ]]; then
    return 0
  fi
  return 1
}

function zcal::current-month() {
  print -P '%D{%m}'
}

function zcal::current-year() {
  print -P '%D{%Y}'
}

function zcal::nth-day() {
  local year=$1
  local month=$2
  local nth=$3
  local day_of_week=$4
  local -A offsets=(1 1 2 8 3 15 4 22 5 29)
  local offset="${offsets[$nth]}"
  local offset_day_of_week=$(date +%u -d "$year-$month-${offset}")
  echo "$year-$month-$(( offset + (day_of_week - offset_day_of_week + 7) % 7 ))"
}
