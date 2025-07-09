(local {:protected_call protected-call
        &as gears}
       (require :gears))

(local {: pointer} cwc)

(when (cwc.is_startup)
  (protected-call require :oneshot))

(protected-call require :keybinds)
