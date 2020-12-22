#!/bin/zsh

function zcal::holidays() {
  local year=$1
  local -A year_holidays=()

  if [[ $year == <1949-> ]]; then
    year_holidays[$year-1-1]="元日"
  fi

  if [[ $year == <2000-> ]]; then
    year_holidays[$(zcal::nth-day $year 1 2 1)]="成人の日"
  elif [[ $year == <1949-1999> ]]; then
    year_holidays[$year-1-15]="成人の日"
  fi

  if [[ $year == <1967-> ]]; then
    year_holidays[$year-2-11]="建国記念の日"
  fi

  if [[ $year == <2020-> ]]; then
    year_holidays[$year-2-23]="天皇誕生日"
  fi

  if [[ $year == <2007-> ]]; then
    year_holidays[$year-4-29]="昭和の日"
  elif [[ $year == <1949-1988> ]]; then
    year_holidays[$year-4-29]="天皇誕生日"
  elif [[ $year == <1989-2006> ]]; then
    year_holidays[$year-4-29]="みどりの日"
  fi

  if [[ $year == <1949-> ]]; then
    year_holidays[$year-5-3]="憲法記念日"
  fi

  if [[ $year == <2007-> ]]; then
    year_holidays[$year-5-4]="みどりの日"
  fi

  if [[ $year == <1949-> ]]; then
    year_holidays[$year-5-5]="こどもの日"
  fi

  if [[ $year == <2003-> && $year != 2020 && $year != 2021 ]]; then
    year_holidays[$(zcal::nth-day $year 7 3 1)]="海の日"
  elif [[ $year == <1996-2002> ]]; then
    year_holidays[$year-7-20]="海の日"
  elif [[ $year = 2020 ]]; then
    year_holidays[$year-7-23]="海の日"
  elif [[ $year = 2021 ]]; then
    year_holidays[$year-7-22]="海の日"
  fi

  if [[ $year == <2016-> && $year != 2020 && $year != 2021 ]]; then
    year_holidays[$year-8-11]="山の日"
  elif [[ $year = 2020 ]]; then
    year_holidays[$year-8-10]="山の日"
  elif [[ $year = 2021 ]]; then
    year_holidays[$year-8-8]="山の日"
  fi

  if [[ $year == <2003-> ]]; then
    year_holidays[$(zcal::nth-day $year 9 3 1)]="敬老の日"
  elif [[ $year == <1966-2002> ]]; then
    year_holidays[$year-9-15]="敬老の日"
  fi

  if [[ $year == <2022-> ]]; then
    year_holidays[$(zcal::nth-day $year 10 2 1)]="スポーツの日"
  elif [[ $year == <2000-2019> ]]; then
    year_holidays[$(zcal::nth-day $year 10 2 1)]="体育の日"
  elif [[ $year == <1966-1999> ]]; then
    year_holidays[$year-10-10]="体育の日"
  elif [[ $year = 2020 ]]; then
    year_holidays[$year-7-24]="スポーツの日"
  elif [[ $year = 2021 ]]; then
    year_holidays[$year-7-23]="スポーツの日"
  fi

  if [[ $year == <1948-> ]]; then
    year_holidays[$year-11-3]="文化の日"
  fi

  if [[ $year == <1948-> ]]; then
    year_holidays[$year-11-23]="勤労感謝の日"
  fi

  if [[ $year == <1989-2018> ]]; then
    year_holidays[$year-12-23]="天皇誕生日"
  fi

  if [[ $year == <1980-2099> ]]; then
    year_holidays[$year-3-$(zcal::vernal-equinox-1980-2099 $year)]="春分の日"
  elif [[ $year == <1949-1979> ]]; then
    year_holidays[$year-3-$(zcal::vernal-equinox-1949-1979 $year)]="春分の日"
  elif [[ $year == <2100-2150> ]]; then
    year_holidays[$year-3-$(zcal::vernal-equinox-2100-2150 $year)]="春分の日"
  fi

  if [[ $year == <1980-2099> ]]; then
    year_holidays[$year-9-$(zcal::autumnal-equinox-1980-2099 $year)]="秋分の日"
  elif [[ $year == <1948-1979> ]]; then
    year_holidays[$year-9-$(zcal::autumnal-equinox-1948-1979 $year)]="秋分の日"
  elif [[ $year == <2100-2150> ]]; then
    year_holidays[$year-9-$(zcal::autumnal-equinox-2100-2150 $year)]="秋分の日"
  fi

  if [[ $year = 2019 ]]; then
    year_holidays[$year-10-22]="即位礼正殿の儀"
  elif [[ $year = 1990 ]]; then
    year_holidays[$year-11-12]="即位礼正殿の儀"
  fi

  if [[ $year = 2019 ]]; then
    year_holidays[$year-5-1]="天皇の即位の日"
  fi

  if [[ $year = 1993 ]]; then
    year_holidays[$year-6-9]="皇太子徳仁親王の結婚の儀"
  fi

  if [[ $year = 1989 ]]; then
    year_holidays[$year-2-24]="昭和天皇の大喪の礼"
  fi

  if [[ $year = 1959 ]]; then
    year_holidays[$year-4-10]="皇太子明仁親王の結婚の儀"
  fi


  local -a year_holidays_list=( "${(k)year_holidays[@]}" )
  # 振替休日
  if [[ $year == <2007-> ]]; then
    for day in "${year_holidays_list[@]}"; do
      if [[ "$(zcal::day-of-week "${(s:-:)day}")" = 7 ]]; then
        while [[ "${+year_holidays[$day]}" = 1 ]]; do
          day=$(zcal::next-day $day)
        done
        year_holidays[$day]="振替休日"
      fi
    done
  elif [[ $year == <1973-> ]]; then
    local threshold=1973-4-12
    for day in "${year_holidays_list[@]}"; do
      if [[ "$(zcal::day-of-week "${(s:-:)day}")" = 7 && $(zcal::date-compare "${threshold}" "${day}") -ge 0 ]]; then
        year_holidays[$(zcal::next-day $day)]="振替休日"
      fi
    done
  fi

  # 国民の休日
  if [[ $year == <1986-> ]]; then
    for day in "${year_holidays_list[@]}"; do
      local next_day="$(zcal::next-day "${day}")"
      local next_next_day="$(zcal::next-day "${next_day}")"
      if [[ "${+year_holidays[$next_next_day]}" = 1 && "${+year_holidays[$next_day]}" = 0 && $(zcal::day-of-week "${next_day}") != 6 ]]; then
        year_holidays[$next_day]="国民の休日"
      fi
    done
  fi

  print "${(qkv)year_holidays[@]}"
}

function zcal::vernal-equinox-1980-2099() {
  local year=$1
  local -i a=$(( 20.8431+0.242194*(year-1980) ))
  local -i b=$(( (year-1980)/4.0 ))
  print $(( a - b ))
}

function zcal::vernal-equinox-1949-1979() {
  local year=$1
  local -i a=$(( 20.8357+0.242194*(year-1980) ))
  local -i b=$(( (year-1983)/4.0 ))
  print $(( a - b ))
}

function zcal::vernal-equinox-2100-2150() {
  local year=$1
  local -i a=$(( 21.8510+0.242194*(year-1980) ))
  local -i b=$(( (year-1980)/4.0 ))
  print $(( a - b ))
}

function zcal::autumnal-equinox-1980-2099() {
  local year=$1
  local -i a=$(( 23.2488+0.242194*(year-1980) ))
  local -i b=$(( (year-1980)/4.0 ))
  print $(( a - b ))
}

function zcal::autumnal-equinox-1948-1979() {
  local year=$1
  local -i a=$(( 23.2588+0.242194*(year-1980) ))
  local -i b=$(( (year-1983)/4.0 ))
  print $(( a - b ))
}

function zcal::autumnal-equinox-2100-2150() {
  local year=$1
  local -i a=$(( 24.2488+0.242194*(year-1980) ))
  local -i b=$(( (year-1980)/4.0 ))
  print $(( a - b ))
}
