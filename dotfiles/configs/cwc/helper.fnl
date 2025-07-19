(local {:spawn_with_shell spawn} cwc)

(lambda spawn-app [cmd]
  "spawn an executable with app2unit in app slice"
  (spawn (.. "app2unit -- " cmd)))

(lambda spawn-background [cmd]
  "spawn an executable with app2unit in background slice"
  (spawn (.. "app2unit -- " cmd)))

(lambda spawn-session [cmd]
  "spawn an executable with app2unit in session slice"
  (spawn (.. "app2unit -- " cmd)))

(lambda percent->number [max-value value]
  "converts a percent unit to a number"
  (/ (* value max-value) 100))

{: spawn-app : percent->number}
