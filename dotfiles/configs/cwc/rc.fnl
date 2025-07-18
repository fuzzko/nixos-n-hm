(local {:protected_call protected-call &as gears} (require :gears))

(local {: pointer : kbd} cwc)

(require :keybinds)

(do "uwsm integration"
  (cwc.setenv :APP2UNIT_SLICES "a=app-graphical.slice b=background-graphical.slice s=session-graphical.slice"))

(let [theme :catppuccin-mocha-sky-cursors
      size 20]
  (cwc.setenv :HYPRCURSOR_THEME theme)
  (cwc.setenv :XCURSOR_THEME theme)
  (cwc.setenv :XCURSOR_SIZE (tostring size))
  (pointer.set_cursor_size size)
  (pointer.set_inactive_timeout 5)
  (pointer.set_edge_threshold 32)
  (pointer.set_edge_snapping_overlay_color 0.1 0.2 0.3 0.05))

(let [repeat-rate 30
      repeat-delay 300]
  (kbd.set_repeat_rate repeat-rate)
  (kbd.set_repeat_delay repeat-delay))

(when (cwc.is_startup)
  (require :startup))

nil
