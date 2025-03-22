#!/usr/bin/env nu

$env.last = (hyprctl workspaces -j)

def filter_json []: string -> string {
  $in
  | from json
  | each { |x|
    if ($x.name =~ ^special) {
      return null
    }
    $x
  }
  | to json -r
}

$env.state = 0;

def _loop []: nothing -> nothing {
  let $workspaces = hyprctl workspaces -j
  let $serialized_workspaces = $workspaces | filter_json
  if ($env.last != $workspaces) {
    $env.last = $workspaces
    $env.state += 1
    print $serialized_workspaces
  }
}

def main []: nothing -> nothing {
  print ($env.last | filter_json)
  while (true) {
    print ($env.state)
    _loop
  }
}
