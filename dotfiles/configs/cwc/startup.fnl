(local {:spawn_with_shell spawn} cwc)

(lambda spawn-app [cmd]
  (spawn (.. "app2unit -- " cmd)))

(spawn (table.concat ["uwsm finalize"
                      :CWC_SOCK
                      :HYPRCURSOR_THEME
                      :XCURSOR_THEME
                      :XCURSOR_SIZE] " "))

(spawn-app "foot")
