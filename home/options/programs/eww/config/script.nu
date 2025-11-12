const cache_path = "~/.cache/eww";

def "main pop" [window: string] {
  if (eww list-windows | str contains $window) == null {
    exit 1
  }

  let lockfile = [$cache_path $"($window).lock"] | path join

  if ($window | path exists)
}
