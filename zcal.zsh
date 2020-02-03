#!/bin/zsh

source "${0:h}/lib/zcal/core.zsh"
source "${0:h}/lib/zcal/holiday.zsh"
source "${0:h}/lib/zcal/holiday/jp.zsh"
source "${0:h}/lib/zcal/output.zsh"

function zcal() {
  local month="${1:-"$(zcal::current-month)"}"
  local year="${2:-"$(zcal::current-year)"}"
  local days_in_month=( $(zcal::days-in-month "${year#0}" "${month#0}") )
  zcal::print ${days_in_month[@]}
}
