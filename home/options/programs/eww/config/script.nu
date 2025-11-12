const cache_path = "~/.cache/eww"

alias eww = ^$env.EWW_CMD

def "main pop" [window: string, ...args: string] {
  if (eww list-windows | str contains $window) == null {
    exit 1
  }

  let lockfile = [$cache_path $"($window).lock"] | path join

  if ($lockfile | path exists) {
    rm -f $lockfile
    eww close $window ...$args
  } else {
    touch $lockfile
    eww open $window ...$args
  }
}
