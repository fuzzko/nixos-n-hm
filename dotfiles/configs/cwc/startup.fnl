(local {:filesystem fs} (require :gears))
(local {: spawn-app : spawn-background} (require :helper))

(local {:spawn_with_shell spawn} cwc)


(spawn (table.concat ["uwsm finalize"
                      :CWC_SOCK
                      :HYPRCURSOR_THEME
                      :XCURSOR_THEME
                      :XCURSOR_SIZE] " "))

; (spawn-background "swww-daemon")
; (spawn-app (.. "swww img " (fs.get_configuration_dir) "wallpapers/default.jpg"))
(spawn "foot")
