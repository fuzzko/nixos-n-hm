#!/usr/bin/env nu
const cache_path = "~/.cache/eww" | path expand

def eww [...args] {
  let cmd = $env.EWW_CMD | split row ' ' | get 0
  let argv = $env.EWW_CMD | split row ' ' | reject 0
  ^$cmd ...$argv ...$args
}

def main [...args] {
}

def "main pop" [window: string] {
  if (eww list-windows | str contains $window) == null {
    exit 1
  }

  let lockfile = [$cache_path $"($window).lock"] | path join


  if ($lockfile | path exists) {
    rm -f $lockfile
    eww close $window
  } else {
    touch $lockfile
    eww open $window
  }

  null
}

def "main toggle" [var: string] {
  let value = do {
    eww get $var | ignore
    if $env.LAST_EXIT_CODE > 0 {
      exit 1
    }
    eww get $var | into bool
  }

  eww update $"($var)=(not $value)"
}

def "main close-all-subwin" [] {
  let windows = [
    [calendar-module reveal-calendar]
  ]

  $windows
  | par-each { |x|
    let win = $x.0
    let var = $x.1

    eww update $"($var)=false"
    eww close $win
  }
}
