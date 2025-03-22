#!/usr/bin/env nu

$env.last = (hyprctl workspaces -j)

def filter []: string -> string {
    from json
    | each { |x|
      if ($x.name =~ ^special) {
        return null
      }
      $x
    }
    | to json -r
}

def _loop []: nothing -> nothing {
  let $workspaces = hyprctl workspaces -j
  let $serialized_workspaces = $workspaces
    | from json
    | each { |x|
      if ($x.name =~ ^special) {
        return null
      }
      $x
    }
    | to json -r
  if ($env.last != $workspaces) {
    $env.last = $workspaces
    print $serialized_workspaces
  }
}

def main []: nothing -> nothing {
  print ($env.last | from json  
  while (true) {
    _loop
  }
}
