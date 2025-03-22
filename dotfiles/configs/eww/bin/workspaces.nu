#!/usr/bin/env nu

def loop []: string -> string {
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
  if ($in != $serialized_workspaces) {
    print $serialized_workspaces
  }
  $serialized_workspaces | loop
}

def main []: nothing -> string {
  "" | loop
}
