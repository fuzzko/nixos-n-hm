(local {:spawn_with_shell spawn : screen : client} cwc)

(lambda spawn-app [cmd]
  (spawn (.. "app2unit -- " cmd)))

(lambda percent->pixel [num]
  (let [current-screen (screen.focused)
        width current-screen.width]
    (/ (* num width) 100)))

{: spawn-app}
