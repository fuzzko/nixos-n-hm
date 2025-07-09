(local {: protected-call
        &as gears}
       (require :gears))

(local {: pointer
        : kbd}
       cwc)

(when (cwc.is_startup)
  (protected-call require :oneshot))

(protected-call require :keybinds)

(do "pointer config"
  (set pointer.cursor_size 20)
  (set pointer.inactive_timeout 5)
  (set pointer.edge_threshold 32)
  (pointer.set_edge_snapping_overlay_color .1 .2 .3 .05))
