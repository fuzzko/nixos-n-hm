(local {: enum &as cfl} (require :cuteful))
(local {&as gears} (require :gears))

(local {:modifier mod :mouse_btn button} enum)

(local {: pointer : client : kbd} cwc)

(local mod-key mod.LOGO)
(local terminal "footclient || foot")

(let [{: stop_interactive : move_interactive : resize_interactive} pointer
      bind (partial pointer.bind mod-key)]
  (bind button.LEFT move_interactive stop_interactive)
  (bind button.RIGHT resize_interactive stop_interactive)
  (bind button.MIDDLE
        #(case (client.focused)
           client* (set client*.floating (not client*.floating)))))

(let [bind (partial kbd.bind mod-key)
      bind-ctrl (partial kbd.bind [mod-key mod.CTRL])]
  (bind-ctrl :Delete cwc.quit)
  (bind-ctrl :r cwc.reload))
