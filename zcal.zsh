#!/bin/zsh

source "$(dirname $0)/lib/zcal/core.zsh"
source "$(dirname $0)/lib/zcal/holiday.zsh"
source "$(dirname $0)/lib/zcal/holiday/jp.zsh"
source "$(dirname $0)/lib/zcal/output.zsh"

function zcal() {
  local month="${1:-"$(zcal::current-month)"}"
  local year="${2:-"$(zcal::current-year)"}"
  local days_in_month=( $(zcal::days-in-month "${year}" "${month}") )
  zcal::print-x ${days_in_month[@]}
}
