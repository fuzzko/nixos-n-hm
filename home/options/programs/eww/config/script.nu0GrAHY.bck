const cache_path = "~/.cache/eww" | path expand

def eww [...args] {
  let cmd = $env.EWW_CMD | split words | get 0
  let argv = $env.EWW_CMD | split words | reject 0
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
