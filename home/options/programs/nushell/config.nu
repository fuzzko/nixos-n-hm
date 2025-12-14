let autoload = $nu.data-dir | path join "vendor/autoload"

if (which starship | is-not-empty) and not ($autoload | path join "starship.nu" | path exists) {
  starship init nu | save ($autoload | path join "starship.nu")
}

