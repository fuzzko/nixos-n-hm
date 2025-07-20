(local {: enum &as cfl} (require :cuteful))
(local {&as gears} (require :gears))
(local {: spawn-app} (require :helper))

(local {:modifier mod :mouse_btn button} enum)

(local {: pointer : client : kbd} cwc)

(local mod-key (if (cwc.is_nested)
                   mod.ALT
                   mod.LOGO))

(local terminal "footclient || foot")

(let [{: stop_interactive : move_interactive : resize_interactive} pointer
      bind (partial pointer.bind mod-key)
      bind-shift (partial pointer.bind [mod-key mod.SHIFT])]
  (bind button.LEFT move_interactive stop_interactive)
  (bind button.RIGHT resize_interactive stop_interactive)
  (bind-shift button.RIGHT
              #(case (client.focused)
                 client* (set client*.floating (not client*.floating)))))

(let [bind (partial kbd.bind mod-key)
      bind-ctrl (partial kbd.bind [mod-key mod.CTRL])]
  (bind-ctrl :Delete cwc.quit)
  (bind-ctrl :r cwc.reload)
  (bind :t #(spawn terminal)))
