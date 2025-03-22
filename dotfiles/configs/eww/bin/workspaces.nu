#!/usr/bin/env nu

def main []: nothing -> string {
  let $workspaces = hyprctl workspaces -j
  print ($workspaces
  | from json
  | each { |x|
    if ($x.name =~ ^special) {
      return null
    }
    $x
  }
  | to json -r)
  main
}
