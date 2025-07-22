(local {: enum : tag :client cfl-client &as cfl} (require :cuteful))
(local {&as gears} (require :gears))
(local {: spawn-app} (require :helper))

(local {:modifier mod :mouse_btn button : direction} enum)

(local {: pointer : client : kbd : container : screen} cwc)

(local mod-key (if (cwc.is_nested)
                   mod.ALT
                   mod.LOGO))

(local terminal "footclient || foot")

(let [{: stop_interactive : move_interactive : resize_interactive} pointer
      bind (partial pointer.bind mod-key)
      bind-shift (partial pointer.bind [mod-key mod.SHIFT])]
  ;; Input binds
  (bind button.LEFT move_interactive stop_interactive)
  (bind button.RIGHT resize_interactive stop_interactive)
  (bind-shift button.RIGHT
              #(case (client.focused)
                 client* (set client*.floating (not client*.floating)))))

(let [bind (partial kbd.bind mod-key)
      bind-ctrl (partial kbd.bind [mod-key mod.CTRL])
      bind-shift (partial kbd.bind [mod-key mod.SHIFT])
      bind-ctrl-shift (partial kbd.bind [mod-key mod.CTRL mod.SHIFT])]
  ;; General binds
  (bind-ctrl :Delete cwc.quit)
  (bind-ctrl :r cwc.reload)
  (bind :t #(spawn-app terminal))
  (bind :Delete #(collectgarbage :collect))
  (bind :Escape container.reset_mark)
  (bind-shift :q #(case (client.focused)
                    c (c:close)))
  (bind-ctrl :q #(case (client.focused)
                   c (c:kill)))
  ;; Change TTY binds
  (for [i 1 12]
    (let [str-i (tostring i)]
      (kbd.bind [mod.CTRL mod.ALT] (.. :F str-i) #(cwc.chvt i))))
  ;; Tag binds
  (for [i 1 9]
    (let [str-i (tostring i)]
      (bind str-i #(-> (screen.focused)
                       (: :get_tag i)
                       (: :view_only)))
      (bind-ctrl str-i #(-> (screen.focused)
                            (: :get_tag i)
                            (: :toggle)))
      (bind-shift str-i
                  #(case (client.focused)
                     client* (client*:move_to_tag str-i)))
      (bind-ctrl-shift str-i
                       #(case (client.focused)
                          client* (client*:toggle_tag str-i)))))
  (bind :0 #(let [screens (screen.get)]
              (each [_ screen* (pairs screens)]
                (tag.viewnone screen*))))
  (bind :comma tag.viewprev)
  (bind :period tag.viewnext)
  (bind :grave tag.history.restore)
  (bind :equal #(tag.incgap 1))
  (bind :minus #(tag.incgap -1))
  ;; Navigation binds
  (each [_ k (pairs [:Left :Up :Right :Down])]
    (bind k #(case (client.focused)
               client* (case (client*:get_nearest (. direction (k:upper)))
                         nearest (nearest:focus)))))
  ;; Changing client state binds
  (bind :v
        #(case (client.focused)
           client* (do
                     (set client*.maximized (not client*.maximized))
                     (set client*.floating (not client*.floating)))))
  (bind :f
        #(case (client.focused)
           client* (set client*.fullscreen (not client*.fullscreen))))
  (bind :j #(case (client.focused)
              client* (let [{: x : y} client*.geometry]
                        (if (> x y)
                            (cfl-client.maximize_vertical)
                            (cfl-client.maximize_horizontal))))))
