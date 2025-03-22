#!/usr/bin/env nu


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

def main []: nothing -> nothing {
  $env.last_ids = (do {
    let $workspaces = hyprctl workspaces -j
    $workspaces | filter_json
  })
  print ($env.last_ids | to json -r)
  while (true) {
    let $workspaces = hyprctl workspaces -j
    let $ids = $workspaces | filter_json
    if ($ids.last_ids != $ids) {
      print ($ids | to json -r)
    }
  }
}
