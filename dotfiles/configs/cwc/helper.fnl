(local {:spawn_with_shell spawn} cwc)
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

{: spawn-app : percent->number}
