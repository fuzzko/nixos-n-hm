(local {: enum &as cfl} (require :cuteful))
(local {&as gears} (require :gears))

(local {:modifier mod :mouse_btn button} enum)

(local {: pointer : client} cwc)

(local mod-key mod.LOGO)
(local terminal "footclient || foot")

(let [{: stop_interactive : move_interactive : resize_interactive} pointer
      bind (partial pointer.bind mod-key)]
  (bind button.LEFT move_interactive stop_interactive)
  (bind button.RIGHT resize_interactive stop_interactive)
  (bind button.MIDDLE #(let [position (pointer.get_position)]
                         (case (client.at (unpack position))
                           client* (set client*.floating (not client*.floating))
                           nil nil))))
