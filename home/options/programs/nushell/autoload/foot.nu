## Nushell integration for Foot

if $nu.is-interactive and $env.TERM == foot {
  let hostname = (sys host).hostname

  $env.config.hooks.env_change.PWD = $env.config.hooks.env_change.PWD? | default []

  # https://codeberg.org/dnkl/foot/wiki#spawning-new-terminal-instances-in-the-current-working-directory  
  $env.config.hooks.env_change.PWD ++= [{
    let pwd = $env.PWD | url encode
    print -n $"\e]7;file://$($hostname)$($pwd)\e\\"
  }]

  $env.config.hooks.pre_prompt ++= [
    # https://codeberg.org/dnkl/foot/wiki#jumping-between-prompts
    { print -n "\e]133;A\e\\" }

    # https://codeberg.org/dnkl/foot/wiki#piping-last-command-s-output
    { print -n "\e]133;D\e\\" }
  ]

  $env.config.hooks.pre_execution ++= [
    # https://codeberg.org/dnkl/foot/wiki#piping-last-command-s-output
    { print -n "\e]133;C\e\\" }
  ]
}
