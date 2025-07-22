(local {:spawn_with_shell :client cwc-client spawn} cwc)
(local app-prefix (if (cwc.is_nested) "" "app2unit -s a --"))
(local background-prefix (if (cwc.is_nested) "" "app2unit -s b  --"))
(local session-prefix (if (cwc.is_nested) "" "app2unit -s s --"))

(lambda spawn-app [cmd]
  "spawn an executable with app2unit in app slice"
  (spawn (.. app-prefix cmd)))

(lambda spawn-background [cmd]
  "spawn an executable with app2unit in background slice"
  (spawn (.. background-prefix cmd)))

(lambda spawn-session [cmd]
  "spawn an executable with app2unit in session slice"
  (spawn (.. session-prefix cmd)))

(lambda percent->number [max-value value]
  "converts a percent unit to a number"
  (/ (* value max-value) 100))

(lambda make-vertical [client]
  "make the client stretch vertically"
  (case (or client (cwc-client.focused))
    client* (let [workarea client*.screen.workarea
                  new-geometry client*.geometry]
              (set new-geometry.y workarea.y)
              (set new-geometry.height workarea.height)
              (set c.geometry new-geometry))))

(lambda make-horizontal [client]
  "make the client stretch horizontally"
  (case (or client (cwc-client.focused))
    client* (let [workarea client*.screen.workarea
                  new-geometry client*.geometry]
              (set new-geometry.x workarea.x)
              (set new-geometry.width workarea.width)
              (set c.geometry new-geometry))))

{: spawn-app : spawn-background : spawn-session : percent->number : make-vertical : make-horizontal}
