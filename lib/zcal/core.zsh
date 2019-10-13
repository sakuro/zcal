#!/bin/zsh

function zcal::days-in-month() {
  local year="$1"
  local month="$2"
  local end_of_month=$(zcal::end-of-month "${year}" "${month}")
  local dates=( "${year}-${month}-"{1.."${end_of_month}"} )
  local weekdays=( {1..7} {1..7} )
  local first_day_of_week="$(zcal::day-of-week $year $month 1)"
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
  local offset_day_of_week=$(zcal::day-of-week $year $month $offset)
  echo "$year-$month-$(( offset + (day_of_week - offset_day_of_week + 7) % 7 ))"
}

# Zeller's congruence without Julian calendar support
function zcal::day-of-week() {
  local year=$1
  local month=$2
  local day=$3

  if [[ $month == <1-2> ]]; then
    month=$((month + 12))
    year=$((year - 1))
  fi

  local -i c=$((year / 100))
  local -i y=$((year % 100))
  local -i t1=$((26 * (month + 1) / 10))
  local -i t2=$((y / 4))
  local -i t3=$((c / 4))
  local -i g=$((-c * 2 + t3))
  echo $(( (day + t1 + y + t2 + g + 5) % 7 + 1))
}

function zcal::next-day() {
  local date_fields=( "${(s:-:)1}" )
  local year="${date_fields[1]}"
  local month="${date_fields[2]}"
  local day="${date_fields[3]}"
  local end_of_month=$(zcal::end-of-month $year $month)

  day=$(( day + 1 ))
  if [[ $day -gt $end_of_month ]]; then
    day=1
    month=$(( month + 1 ))
    if [[ $month = 13 ]]; then
      month=1
      year=$(( year + 1 ))
    fi
  fi
  echo "$year-$month-$day"
}

function zcal::date-compare() {
  local date_a=( "${(s:-:)1}" )
  local date_b=( "${(s:-:)2}" )
  for i in {1..3}; do
    if [[ $date_a[$i] -gt $date_b[$i] ]]; then
      return -1
    elif [[ $date_a[$i] -lt $date_b[$i] ]]; then
      return 1
    fi
  done
  return 0
}
