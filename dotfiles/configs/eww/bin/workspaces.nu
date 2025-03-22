#!/usr/bin/env nu

$env.last = (hyprctl workspaces -j)

def filter_json []: string -> list<int> {
  $in
  | from json
  | each { |x|
    if ($x.name =~ ^special) {
      return null
    }
    $x.id
  }
}

$env.state = 0;

def _loop []: nothing -> nothing {
  let $workspaces = hyprctl workspaces -j
  let $workspaces_id = $workspaces | filter_json
  
}

def main []: nothing -> nothing {
  print ($env.last | filter_json)
  while (true) {
    print ($env.state)
    _loop
  }
}
