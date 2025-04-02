#!/usr/bin/env nu

def main []: nothing -> nothing {
  $env.last_ids = (hyprctl activeworkspace -j)
  print ($env.last_ids | to json -r)
  while (true) {
    let $workspaces = hyprctl workspaces -j
    let $ids = $workspaces | filter_json
    if ($env.last_ids != $ids) {
      print ($ids | to json -r)
      $env.last_ids = $ids
    }
  }
}
