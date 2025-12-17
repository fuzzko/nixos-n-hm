use std/config *

let autoload = $nu.data-dir | path join "vendor/autoload"

if (which direnv | is-not-empty) {
  $env.config.hooks.env_change.PWD = $env.config.hooks.env_change.PWD? | default []

  $env.config.hooks.env_change.PWD ++= [{||
    direnv export json | from json | default {} | load-env
    $env.PATH = do (env-conversions).path.from_string $env.PATH
  }]
}
