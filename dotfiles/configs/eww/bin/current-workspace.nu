#!/usr/bin/env nu

def main []: nothing -> nothing {
  $env.last_activeworkspace = (hyprctl activeworkspace -j | from json)
  print ($env.last_activeworkspace | to json -r)
  while (true) {
    sleep 
    let $active_workspace = hyprctl activeworkspace -j | from json
    if ($env.last_activeworkspace != $active_workspace) {
      print ($active_workspace | to json -r)
      $env.last_ids = $active_workspace
    }
  }
}
