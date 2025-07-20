(local {:protected_call protected-call : color &as gears} (require :gears))
(local {: percent->number : spawn-background} (require :helper))

(local {: pointer : kbd : client} cwc)

(require :keybinds)

(do
  (cwc.setenv :APP2UNIT_SLICES
              "a=app-graphical.slice b=background-graphical.slice s=session-graphical.slice"))

(let [theme :catppuccin-mocha-rosewater-cursors
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

(do
  (client.set_border_color_focus (color {:type :linear
                                         :from [0 0]
                                         :to [0 0]
                                         :stops [[0.3 "#fab387"] [1 "#f9e2af"]]}))
  (client.set_border_color_normal (color "#313244")))

;; border width
(cwc.connect_signal "client::map"
                    (fn [client*]
                      (set client*.border_width
                           (-> (percent->number client*.screen.width 0.4)
                               (+ 0.5)
                               (math.floor)))))

;; center floating client
(cwc.connect_signal "client::map"
                    (fn [client*]
                      (when client*.floating
                        (client*:center))))

;; focus client
(cwc.connect_signal "client::map"
                    (fn [client*]
                      (case client*.focused
                        (where focused
                               (and focused.fullscreen
                                    (not= client*.parent focused)))
                        (client*:lower)
                        _ (do
                            (client*:raise)
                            (client*:focus)))))

(cwc.connect_signal "signal::unmap"
                    (fn [client*]
                      (when (= client* (client.focused))
                        (case client*.container.client_stack
                          (where stack (> 1 (length stack))) (: (. stack 2)
                                                                :focus)
                          _ (let [latest-focus-after (. (client*.screen:get_focus_stack true)
                                                        2)]
                              (when latest-focus-after
                                (latest-focus-after:focus)))))))

(when (cwc.is_startup)
  (require :startup))
