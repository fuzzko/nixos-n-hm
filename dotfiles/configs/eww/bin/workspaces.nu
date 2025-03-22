#!/usr/bin/env nu

$env.last = ""

def loop []: string -> nothing {
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
    $env.last = $in
    print $serialized_workspaces
  }
}

def main []: nothing -> nothing {
  while (true) {
    $env.last | loop
  }
}
