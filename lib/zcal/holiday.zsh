#!/bin/zsh

function xdg::cache-home {
  echo "${HOME}/.cache"
}

funcion zcal::holidays-cache-path() {
  local cache_path
  zstyle -s ':zcal:' cache-path cache_path || cache_path="$(xdg::cache-home)/zsh/zcal-holidays"
  [[ -f "${cache_path}" ]] || mkdir -p "${cache_path:h}" && touch "${cache_path}"
  echo "${cache_path}"
}

function zcal::load-holidays-cache() {
  local year=$1
  local -A holidays=()
  source "$(zcal::holidays-cache-path)"
  if [[ "${#${(M)${(k)holidays}#$year-}}" = 0 ]]; then
    holidays=( $(zcal::update-holidays-cache "${year}") )
  fi
  echo "${(qkv)holidays[@]}"
}

function zcal::update-holidays-cache() {
  local year=$1
  local -A holidays=()
  source "$(zcal::holidays-cache-path)"

  local -A year_holidays=( $(zcal::holidays "${year}") )
  for date in "${(ok)year_holidays[@]}"; do
    holidays[$date]=${year_holidays[$date]}
  done

  zcal::dump-holidays-cache "${(kv)holidays[@]}"
  echo "${(qkv)holidays[@]}"
}

function zcal::dump-holidays-cache() {
  local cache_path="$(zcal::holidays-cache-path)"
  local -A holidays=( "$@" )

  print "holidays=(" > "${cache_path}"
  for date in ${(ok)holidays}; do
    print -r - "${(qq)date}" "${(qq)holidays[$date]}"
  done >> "${cache_path}"

  print ")" >> "${cache_path}"
}
