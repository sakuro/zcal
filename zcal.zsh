#!/bin/zsh

source "${0:h}/lib/zcal/core.zsh"
source "${0:h}/lib/zcal/holiday.zsh"
source "${0:h}/lib/zcal/holiday/jp.zsh"
source "${0:h}/lib/zcal/output.zsh"

function zcal() {
  local method=print-x
  while getopts lx opt; do
    case "${opt}" in
    l) method=print-l ; shift ;;
    x) method=print-x ; shift ;;
    --)
      break ;;
    esac
  done

  local month="${1:-"$(zcal::current-month)"}"
  local year="${2:-"$(zcal::current-year)"}"
  local days_in_month=( $(zcal::days-in-month "${year#0}" "${month#0}") )
  case $method in
  print-x)
    zcal::print-x ${days_in_month[@]} ;;
  print-l)
    zcal::print-l ${days_in_month[@]} ;;
  esac
}
