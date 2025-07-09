(local {:protected_call protected-call
        &as gears}
       (require :gears))

(local {: pointer
        : kbd}
       cwc)

(require :keybinds)

(let [theme :catppuccin-mocha-sky-cursors
      size 20]
  (cwc.setenv :HYPRCURSOR_THEME theme)
  (cwc.setenv :XCURSOR_THEME theme)
  (cwc.setenv :XCURSOR_SIZE (tostring size))
  (pointer.set_cursor_size size)
  (pointer.set_inactive_timeout 5)
  (pointer.set_edge_threshold 32)
  (pointer.set_edge_snapping_overlay_color .1 .2 .3 .05))

(print (os.getenv "WAYLAND_DISPLAY"))

(when (cwc.is_startup)
  (require :startup))

nil
