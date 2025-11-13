#!/usr/bin/env nu
const cache_path = "~/.cache/eww" | path expand

def eww [...args] {
  let cmd = $env.EWW_CMD | split row ' ' | get 0
  let argv = $env.EWW_CMD | split row ' ' | reject 0
  print $cmd $argv $args
  ^$cmd ...$argv ...$args
}

def main [] {
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
}

def "main toggle-var" [var: string value: any] {
  eww get $var | ignore
  if $env.LAST_EXIT_CODE > 0 {
    exit 1
  }

  eww update $"($var)=($value | into string)"
}
